component {
	variables.config = {charset="utf-8", userAgent="BoltHTTP"};
	
	variables.useJavaLoader = true;

	public function init(struct config={}) {
		initJavaLoader();
		if (!structIsEmpty(arguments.config)) {
			structAppend(variables.config, arguments.config, true);
		}
		variables.charset = create("java.nio.charset.Charset").forName(variables.config.charset);
		variables.entityUtils = create("org.apache.http.util.EntityUtils");
		local.clientBuilder = create("org.apache.http.impl.client.HttpClientBuilder").create();
		local.clientBuilder = local.clientBuilder.setUserAgent(variables.config.userAgent);
		variables.httpClient = local.clientBuilder.build();
		
		return this;
	}

	public function rawRequest(string url, string method="GET", array params=[], struct options={}) {
		var requestBuilder = create("org.apache.http.client.methods.RequestBuilder");
		var cookieHeader = "";
		switch (uCase(arguments.method)) {
			case "GET":
				requestBuilder = requestBuilder.get(arguments.url);
				break;
			case "POST":
				requestBuilder = requestBuilder.post(arguments.url);
				break;
			default:
				requestBuilder = requestBuilder.create(uCase(arguments.method)).setUri(arguments.url);
				break;
		}
		requestBuilder = requestBuilder.setCharset(variables.charset);
		for (local.p in arguments.params) {
			switch (LCase(local.p.type)) {
				case "header":
				case "cgi":
					if (structKeyExists(local.p, "encoded") && local.p.encoded) {
						requestBuilder.addHeader(javaCast("string", local.p.name), urlEncodedFormat(local.p.value));
					} else {
						requestBuilder.addHeader(javaCast("string", local.p.name), javaCast("string", local.p.value));
					}
					break;
				case "body":
					requestBuilder = requestBuilder.setEntity(create("org.apache.http.entity.StringEntity").init(javaCast("string", local.p.value)));
					break;
				case "formfield":
					requestBuilder = requestBuilder.addParameter(javaCast("string", local.p.name), javaCast("string", local.p.value));
					break;
				case "cookie":
					//todo cookies
					if (len(cookieHeader)) {
						cookieHeader = cookieHeader & "; ";
					}
					cookieHeader = cookieHeader & local.p.name & "=";
					if (structKeyExists(local.p, "encoded") && local.p.encoded) {
						cookieHeader = cookieHeader & urlEncodedFormat(local.p.value); 
					} else {
						cookieHeader = cookieHeader & local.p.value; 
					}
					break;
				default:
					throw(message="Unsupported param type:" & XmlFormat(local.p.type));
					break;	
			}
		}
		if (len(cookieHeader)) {
			requestBuilder.addHeader("Cookie", cookieHeader);
		}
		if (!structIsEmpty(arguments.options)) {
			local.requestConfig = create("org.apache.http.client.config.RequestConfig").custom();
			for (local.key in arguments.options) {
				switch(lCase(local.key)) {
					case "maxredirects":
						local.requestConfig = local.requestConfig.setMaxRedirects(arguments.options.maxRedirects);
						break;
					case "redirect":
						local.requestConfig = local.requestConfig.setRedirectsEnabled(arguments.options.redirect);
						break;
					case "sockettimeout":
						local.requestConfig = local.requestConfig.setSocketTimeout(arguments.options.socketTimeout);
						break;
					case "connecttimeout":
						local.requestConfig = local.requestConfig.setConnectTimeout(arguments.options.connectTimeout);
						break;
					case "connectrequesttimeout":
						local.requestConfig = local.requestConfig.setConnectRequestTimeout(arguments.options.connectRequestTimeout);
						break;
					case "compression":
						local.requestConfig = local.requestConfig.setContentCompressionEnabled(arguments.options.compression);
						break;
				}
			}
			requestBuilder.setConfig(local.requestConfig.build());
		}

		try {
			return variables.httpClient.execute(requestBuilder.build());
		} catch (any e) {
			//auto close client on exception
			variables.httpClient.close();
			rethrow;
		}
	}

	public function request(string url, string method="GET", array params=[], boolean close=true, struct options={}) {
		var httpResponse = rawRequest(url=arguments.url, method=arguments.method, params=arguments.params, options=arguments.options);
		
		var result = StructNew();
		result["ErrorDetail"] = "";
		result.text = false;
		result.status = httpResponse.getStatusLine().getStatusCode();
		result.statuscode = httpResponse.getStatusLine().getStatusCode() & " " & httpResponse.getStatusLine().getReasonPhrase();
		result.responseHeader = StructNew();
		result.httpResponse = httpResponse;

		result.header = httpResponse.toString();
		local.headers = httpResponse.getAllHeaders();
		result.responseHeader["Explanation"] = httpResponse.getStatusLine().getReasonPhrase();
		result.responseHeader["Http_Version"] = httpResponse.getStatusLine().getProtocolVersion().toString();
		result.responseHeader["Status_Code"] = result.status;
		for (local.i=1;local.i<=ArrayLen(local.headers);local.i++) {
			local.h = local.headers[local.i];
			if (StructKeyExists(result.responseHeader, local.h.getName())) {
				//if multiple headers with the same name convert to a struct
				//this is odd, but it matches how cfhttp works
				if (isStruct(result.responseHeader[local.h.getName()])) {
					//append to existing struct
					local.i = structCount(result.responseHeader[local.h.getName()]) + 1;
					result.responseHeader[local.h.getName()][local.i] = local.h.getValue();
				} else {
					//convert to struct
					result.responseHeader[local.h.getName()] = {1=result.responseHeader[local.h.getName()], 2=local.h.getValue()};
				}
			} else {
				result.responseHeader[local.h.getName()] = local.h.getValue();
			}
		}

		if (StructKeyExists(result.responseHeader, "Content-Type")) {
			result.mimetype = Trim(ListFirst(result.responseHeader["Content-Type"], ";"));
			if (ListLen(result.responseHeader["Content-Type"], ";") EQ 2) {
				result.charset = Trim(ListGetAt(result.responseHeader["Content-Type"], 2, ";"));
				result.charset = ReplaceNoCase(result.charset, "charset=", "");
			}
			if (result.mimetype.startsWith("text/") OR result.mimetype.startsWith("message/")) {
				result.text = true;
			} else if (result.mimetype.startsWith("application/")) {
				if (ListFindNoCase("application/octet-stream,application/json", result.mimetype)) {
					result.text = true;
				}
			}
		} else if (ListFindNoCase("png,jpg,jpeg,gif,pdf", ListFirst(ListLast(url, "."), "?"))) {
			result.text = false;
		} else {
			result.text = true;
		}
		if (result.text) {
			result.filecontent = variables.entityUtils.toString(httpResponse.getEntity());
		} else {
			result.filecontent = variables.entityUtils.toByteArray(httpResponse.getEntity());
		}
		
		httpResponse.close();

		if (arguments.close) {
			httpClient.close();
		}
		return result;
	}

	

	/**
  	 * Create an instance of a java class
  	 */
	public function create(className) {
		if (variables.useJavaLoader) {
			return server[getLoaderKey()].create(arguments.className);
		} else {
			return createObject("java", arguments.className);
		}
	}

	public function getHttpClient() {
		return variables.httpClient;
	}

	public function getHttpClientVersion() {
		var versionInfo = create("org.apache.http.util.VersionInfo").loadVersionInfo("org.apache.http.client", getHttpClient().getClass().getClassLoader());
		return versionInfo.toString();
	}

	public function getVersion() {
		return "1.0.0";
	}

	private function getLoaderKey() {
		return "bolt_javaloader_" & replace(getVersion(), ".","","ALL");
	}

	private function initJavaLoader() {
		if (variables.useJavaLoader) {
			local.key = getLoaderKey();
			if (!structKeyExists(server, local.key)) {
				server[local.key] = new javaloader.JavaLoader(getJarArray(), false);
			}
		}
	}

	/** 
	 * @returns an array of java jar files used by this tool
	 */
	public function getJarArray() {
		var lib = getDirectoryFromPath(getCurrentTemplatePath()) & "lib/";
		return [
				lib & "commons-logging-1.2.jar", 
				lib & "commons-codec-1.10.jar", 
				lib & "httpcore-4.4.5.jar",
				lib & "httpclient-4.5.2.jar",
				lib & "httpasyncclient-4.1.2.jar"
		];
	}

}
