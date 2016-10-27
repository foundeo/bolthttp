component extends="testbox.system.BaseSpec" {

	function run(testResults, testBox) {
		
		describe("Throw exceptions", function() {
			it("Should throw exception when connecting to an invalid scheme", function() {
				expect(function() {
					var bolt = new bolthttp.bolthttp();
					var result = bolt.request("htp://foo/moo");

				}).toThrow();
				
			});

			it("Should throw exception when connecting to an invalid host", function() {
				expect(function() {
					var bolt = new bolthttp.bolthttp();
					var result = bolt.request("http://192.168");

				}).toThrow();
				
			});

		});
	}

}