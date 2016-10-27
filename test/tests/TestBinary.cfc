component extends="testbox.system.BaseSpec" {

	

	function run(testResults, testBox) {
		

		describe("Test Binary Responses", function() {
			it("should work for a png", function() {
				var bolt = new bolthttp.bolthttp();
				var result = bolt.request(url="http://httpbin.org/image/png", method="GET");
				expect(result.text).toBeFalse();
				expect(result.mimetype).toBe("image/png");
				expect(isBinary(result.fileContent)).toBeTrue("Should be binary");
			});

			

		});
	}
}
