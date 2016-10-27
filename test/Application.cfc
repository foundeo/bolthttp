component {
	this.name="bolt_tests";
	this.projectRoot = Replace(getDirectoryFromPath(getCurrentTemplatePath()), "/test/", "/");
	this.mappings["/testbox"] = this.projectRoot & "testbox"; 
	this.mappings["/bolthttp"] = this.projectRoot;
	this.mappings["/util"] = this.projectRoot & "test/util";
	this.mappings["/tests"] = this.projectRoot & "test/tests";

	//this.javaSettings.loadPaths = [this.projectRoot & "lib"];
	//this.javaSettings.reloadOnChange = true;

	public boolean function onRequestStart(targetPage) {
		if (!isLocalHost(cgi.remote_addr)) {
			writeOutput("Sorry localhost only...");
			abort;
			return false;
		}
		return true;
	}

}