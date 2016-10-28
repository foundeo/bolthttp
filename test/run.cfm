<cfsetting requesttimeout="150" enablecfoutputonly="true">
<cfscript>
if (!structKeyExists(url, "reporter")) {
	reporter = cgi.server_protocol == "CLI/1.0" ? "text" : "simple";
}
</cfscript>
<cfif structKeyExists(server, "coldfusion") AND structKeyExists(server.coldfusion, "productname") AND server.coldfusion.productname contains "ColdFusion" AND ListFirst(server.coldfusion.productversion) EQ 9>
	<!--- For CF9 Testbox does not work so just run the TLS test  --->
	<cfsavecontent variable="test"><cfinclude template="tls-tests.cfm"></cfsavecontent>
	
	<cfif reporter IS "text">
		
		<cfset test = reReplace(test, "[\r\n\t]", "", "ALL")>
		
		<cfset test = replace(test,"</div>", Chr(10), "ALL")>
		<cfset test = replace(test, "</h1>", "#Chr(10)#==============================#Chr(10)#")>
		<cfset test = replace(test, "</h3>", "#Chr(10)##Chr(10)#", "ALL")>
		<cfset test = reReplace(test, "<[^>]+>", "", "ALL")>
		<cfcontent reset="true" type="text/plain"><cfoutput>#test#</cfoutput>
	<cfelse>
		<cfoutput>#test#</cfoutput>
	</cfif>	
	<cfif test contains "FAIL:">
		<cfset exitCode(1)>
	<cfelse>
		<cfset exitCode(0)>
	</cfif>
<cfelse>
	<cfscript>
		function exitCode( required numeric code ) {
			var exitcodeFile = GetDirectoryFromPath( GetCurrentTemplatePath() ) & "/.exitcode";
			FileWrite( exitcodeFile, code );
		}
		try {
			
			testbox = new testbox.system.TestBox( options={}, reporter=reporter, directory="tests");
			writeOutput( testbox.run() );
			resultObject = testbox.getResult();
			errors       = resultObject.getTotalFail() + resultObject.getTotalError();
			exitCode( errors ? 1 : 0 );
		} catch ( any e ) {
			writeOutput( "An error occurred running the tests. Message: [#e.message#], Detail: [#e.detail#]" );
			exitCode( 1 );
		}
	</cfscript>
</cfif>