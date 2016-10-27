<cfparam name="url.src" default="">
<cfparam name="url.ifmodsince" default="">
<cfparam name="url.method" default="GET">
<cfparam name="url.hName" default="">
<cfparam name="url.hVal" default="">
<form action="http.cfm" method="get">
	<cfoutput>
	<input type="text" name="src" size="60" value="#XmlFormat(url.src)#" />
	<select name="method">
		<cfset methods = "GET,POST,HEAD,TRACE,OPTIONS,PROPFIND,PROPGET">
		<cfloop list="#methods#" index="m"><option value="#m#"<cfif m IS url.method> selected="selected"</cfif>>#m#</option></cfloop>
	</select>
	<input type="submit" value="Fetch" />
	<br /><br />
	Form Field Name: <input type="text" name="fname" value="test"> Value: 
	<input type="text" name="fval" value="test">
	<select name="fvalEncoded">
		<option value="1" selected="selected">Encoded</option>
		<option value="0">Not Encoded</option>
	</select>
	<br /><br />
	<small>If-Modified-Since: <input type="text" name="ifmodsince" value="#XmlFormat(url.ifmodsince)#" /></small>
	<br /><br/>
	<small>
		Custom Header Name: <input type="text" name="hName" value="#XmlFormat(url.hname)#" />
		<input type="text" name="hVal" value="#XmlFormat(url.hval)#" />
	</small>
	<br />
	<small>User Agent:</small>
	<input type="text" name="ua" value="" />
	<br />
	<input type="checkbox" name="outputFileContent" value="1"> Output Filecontent
	</cfoutput>
</form>

<cfif Len(url.src)>
	<cfset tick = GetTickCount()>
	<cfif NOT len(url.ua)>
		<cfset url.ua = "ColdFusion">
	<cfelse>
		<cfthrow message="UA not implemented">
	</cfif>

	<cfset bolt = new bolthttp.bolthttp()>
	<cfset params = []>

	
	<cfif Len(url.ifmodsince)>
		<cfset ArrayAppend(params, {name="If-Modified-Since", type="header", value="#url.ifmodsince#"})>
	</cfif>
	<cfif url.method IS "POST">
		<cfset ArrayAppend(params, {name="#url.fname#", value="#url.fval#", type="formfield", encoded="#url.fvalEncoded#"})>
		
	</cfif>
	<cfif Len(url.hName)>
		<cfset ArrayAppend(params, {type="header", name="#url.hName#", value="#url.hVal#"})>		
	</cfif>
	
	<cfset cfhttp = bolt.request(url.src, url.method, params)>

	<cfset tock = GetTickCount()>
	<cfoutput><p>Request Execution Time: #NumberFormat(tock-tick)#ms</p></cfoutput>
	<cfdump var="#cfhttp#">
	
	<cfif StructKeyExists(url, "outputFileContent") AND url.outputFileContent>
		<hr/>
		<cfoutput>#cfhttp.fileContent#</cfoutput>
		<hr/>
	</cfif>
	<cfoutput>
	<cfif StructKeyExists(cfhttp.ResponseHeader, "Set-Cookie")>
		<cfif IsStruct(cfhttp.ResponseHeader["Set-Cookie"])>
			<cfloop collection="#cfhttp.ResponseHeader["Set-Cookie"]#" item="header">
				<div>#cfhttp.ResponseHeader["Set-Cookie"][header]#
				<cfif isSessionCookieWithoutHttpOnly(cfhttp.ResponseHeader["Set-Cookie"][header])>
					NOT HTTP ONLY!
				</cfif>
				</div>
			</cfloop>
		<cfelse>
			<cfset header = cfhttp.ResponseHeader["Set-Cookie"]>
			<cfif isSessionCookieWithoutHttpOnly(header)>
				<div>NOT HTTP ONLY! #header# </div>
			</cfif>	
		</cfif>
	</cfif>
	</cfoutput>
</cfif>



<cffunction name="isSessionCookieWithoutHttpOnly" returntype="boolean" output="false">
		<cfargument name="cookieHeader">
		<cfif FindNoCase("cftoken=", arguments.cookieHeader) OR FindNoCase("cfid=", arguments.cookieHeader) OR FindNoCase("jsessionid=", arguments.cookieHeader)>
			<cfif NOT FindNoCase("httponly", arguments.cookieHeader)>
				<cfreturn true>					
			</cfif>
		</cfif>
		<cfreturn false>
	</cffunction>