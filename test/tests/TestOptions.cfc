component extends="testbox.system.BaseSpec" {

	//http://httpbin.org/

	function run(testResults, testBox) {
		

		describe("Test User Agent", function() {
			it("It should allow you to set the user agent.", function() {
				var bolt = new bolthttp.bolthttp({userAgent="TestUserAgent"});
				var result = bolt.request(url="http://httpbin.org/user-agent", method="GET");
				var rObj = deserializeJSON(result.fileContent);
				expect(rObj["user-agent"]).toBe("TestUserAgent");
			});


		});
	}
}
