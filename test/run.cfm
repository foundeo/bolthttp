<cfsetting requesttimeout="150">

<cfset r = new testbox.system.TestBox( directory="tests" ) >
<cfoutput>#r.run()#</cfoutput>

<cfoutput>
<a href="run.cfm?ts=#GetTickCount()#">ReRun</a>
</cfoutput>