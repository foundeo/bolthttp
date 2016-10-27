component extends="testbox.system.BaseSpec" {

	//

	function run(testResults, testBox) {
		
		describe("Test maps.google.com", function() {
			it("Should connect to https://maps.googleapis.com/robots.txt", function() {
				var bolt = new bolthttp.bolthttp();
				var result = bolt.request("https://maps.googleapis.com/robots.txt");
				expect(result.fileContent).toInclude("Disallow:");
				
			});

			

		});
	}
}