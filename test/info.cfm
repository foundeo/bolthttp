<h2>Bolt Info</h2>
<cfset bolt = new bolthttp.bolthttp()>
<cfoutput>Bolt Version: #bolt.getVersion()# HttpClient Version: #bolt.getHttpClientVersion()#</cfoutput>
<br>
<cfloop array="#bolt.getJarArray()#" index="j">
	<cfoutput>File Exists:#fileExists(j)# #j# </cfoutput><br>
</cfloop>


<h2>Java System Properties</h2>
<cfset system = CreateObject("java", "java.lang.System")>
<!--- properties is a java.util.Properties object --->
<cfset properties = system.getProperties()>
<!--- propNames is a java.util.Enumeration --->
<cfset propNames = properties.propertyNames()>
<cfoutput>
<cfloop condition="propNames.hasMoreElements()">
<cfset propName = propNames.nextElement()>
<strong>#htmlEditFormat(propName)#</strong> = <code>#htmlEditFormat(system.getProperty(propName))#</code><br />
</cfloop>
</cfoutput>