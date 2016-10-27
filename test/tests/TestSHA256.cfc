component extends="testbox.system.BaseSpec" {

	//

	function run(testResults, testBox) {
		
		describe("Test SHA-256 Certificate", function() {
			it("Should connect to https://www.sandbox.paypal.com/robots.txt", function() {
				var bolt = new bolthttp.bolthttp();
				var result = bolt.request("https://www.sandbox.paypal.com/robots.txt");
				expect(result.fileContent).toInclude("Disallow:");
				
			});

			

		});
	}
}