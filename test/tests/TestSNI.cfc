component extends="testbox.system.BaseSpec" {
	function beforeAll(){
		
	}

	function run(testResults, testBox) {
		
		/* THESE servers do not seam to be working
		cfHttp = new util.cfhttp();
		describe("SNI Tests", function() {
			var sniHosts = ["mallory.sni.velox.ch", "dave.sni.velox.ch", "alice.sni.velox.ch"];
			var results = {};
			for (var s in sniHosts) {
				var bolt = new bolthttp.bolthttp();
				results[s] = bolt.request("https://#s#/");
			}
			it("should have sent the SNI extension ", function() {
				for (var s in sniHosts) {
					var boltResult = results[s];
					expect(boltResult.fileContent).toInclude("<strong>#s#</strong>", "No strong tag with host: #s#");	
				}
				
				
			});

			it("should have Host: header", function() {
				for (var s in sniHosts) {
					var boltResult = results[s];
					expect(boltResult.fileContent).toInclude("Host: #s#", "No Host: #s#");
				}
				
			});
			
			

			
		});
		*/
	}

}
