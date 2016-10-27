# BoltHTTP

BoltHTTP is a HTTP client for CFML, it is a CFC that wraps the Apache HttpComponents java library. You can use the `bolthttp` CFC instead of CFHTTP when making HTTP requests within CFML.

## How do I use it?

Here's a simple example:

	bolt = new bolthttp();
	response = bolt.request(url="http://httpbin.org/robots.txt", method="GET");
	writeOutput(response.fileContent);

The return value of `request` value is a `struct` that contains keys _mostly_ compatibale with what the `cfhttp` tag would return. 

The request method has the following signature:

	request(string url, string method="GET", array params=[], boolean close=true, struct options={})

`url` the url to request, the only required argument.

`method` the HTTP request method

`params` similar to the `cfhttpparam` tag, an array of structs for headers, formfields, etc. For example passing a header you would use `[{type="header", name="X-MyHeader", value="My Value"}]`

`close` when `true` it closes the internal HTTP Client for you once the request is complete, this means that you need to create another instance of `bolthttp` if you want to make a subsequent request, or set it to `false` and call `getHttpClient().close()` when you are done with the instance.

`options` a struct of request level options. Currently supported options are: `maxredirects` `redirect` `sockettimeout` `connecttimeout` and `connectrequesttimeout`

## Advanced Usage

The response struct also contains a key `httpResponse` which is an instance of a [http://hc.apache.org/httpcomponents-core-ga/httpcore/apidocs/org/apache/http/HttpResponse.html](org.apache.http.HttpResponse) object. You should be able to get any part of the HTTP response you need from this object.

If you want to only work with the `HttpResponse` object instead of using the `request()` method of bolthttp you can use the `rawRequest()` method which only returns the `HttpResponse` object. Using `rawRequest` instead of `request().httpResponse` will offer better performance becauase it does not need to parse the response object to build the struct. 

## System Requirements

It requires Java 1.7 and ColdFusion 9 or greater or Lucee 4.5+ 

_The requirement of ColdFusion 9+ is mainly due to it being written as a script based CFC, if you convert it to a tag based CFC it would probably run on CF8 or below as well._

## Why use it?

* Consistent implementation of CFHTTP across various CFML engine versions.
* Ability to use TLS 1.2 on ColdFusion 9
* Friendly for script based code