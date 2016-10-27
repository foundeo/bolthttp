component extends="testbox.system.BaseSpec" {

	//http://httpbin.org/

	function run(testResults, testBox) {
		

		describe("Test Compression", function() {
			it("It should support gzip", function() {
				var bolt = new bolthttp.bolthttp();
				var result = bolt.request(url="http://httpbin.org/gzip", method="GET");
				var rObj = deserializeJSON(result.fileContent);
				expect(rObj.gzipped).toBeTrue();
			});

			it("It should support deflate", function() {
				var bolt = new bolthttp.bolthttp();
				var result = bolt.request(url="http://httpbin.org/deflate", method="GET");
				var rObj = deserializeJSON(result.fileContent);
				expect(rObj.deflated).toBeTrue();
			});
			
			/*
			it("It should allow compression to be turned off", function() {
				var bolt = new bolthttp.bolthttp();
				var result = bolt.request(url="http://httpbin.org/gzip", method="GET", options={compression=false});
				var rObj = "";
				debug(result);
				var rObj = deserializeJSON(result.fileContent);
				expect(rObj.gzipped).toBeFalse();
			});*/


		});
	}
}
