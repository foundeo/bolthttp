component extends="testbox.system.BaseSpec" {
	function beforeAll(){
		
	}

	function run(testResults, testBox) {
		
		cfHttp = new util.cfhttp();
		describe("CFHTTP Compatibility Tests", function() {
			var bolt = new bolthttp.bolthttp();
			var data = {};
			data.boltResult = bolt.request("http://httpbin.org/response-headers?X-Men=y&Server=httpbin&Content-Type=text%2Fplain%3B+charset%3DUTF-8");
			data.cfResult = cfHttp.run({url="http://httpbin.org/response-headers?X-Men=y&Server=httpbin&Content-Type=text%2Fplain%3B+charset%3DUTF-8", method="get"});

			
			
			

			it(title="should have the same file content", body=function(data) {
				expect(data.boltResult.fileContent).toBe(data.cfResult.fileContent);
			},data=data);

			it(title="should have the same charset", body=function(data) {
				expect(data.boltResult.charset).toBe(data.cfResult.charset);
			},data=data);

			it(title="should have the same mimetype", body=function(data) {
				expect(data.boltResult.mimetype).toBe(data.cfResult.mimetype);
			},data=data);

			it(title="should have the same text", body=function(data) {
				expect(data.boltResult.text).toBe(data.cfResult.text);
			},data=data);

			it(title="should have the same statuscode", body=function(data) {
				expect(data.boltResult.statuscode).toBe(data.cfResult.statuscode);
			},data=data);

			it(title="should have the same number of response headers", body=function(data) {
				expect(StructCount(data.boltResult.responseheader)).toBe(StructCount(data.cfResult.responseheader));
			},data=data);		

			it(title="should have the same list of response headers", body=function(data) {
				expect(listSort(StructKeyList(data.cfResult.responseheader), "text")).toBe(listSort(StructKeyList(data.boltResult.responseheader), "text"));
			},data=data);	

			//test headers
			for (h in StructKeyArray(data.cfResult.responseheader)) {
				data.h = h;
				it(title="bolt should have the response header: #h#", body=function(data) {
					expect(data.boltResult.responseheader).toHaveKey(data.h);
				}, data=data);	
				if (StructKeyExists(data.boltResult.responseheader, h)) {
					if (isArray(data.cfResult.responseheader[h])) {
						it(title="the response header #h# should be an array", body=function(data) {
							expect(data.boltResult.responseheader[data.h]).toBeArray();
						},data=data);
					} else if (IsStruct(data.cfResult.responseheader[h])) {
						it(title="the response header #h# should be a struct", body=function(data) {
							expect(data.boltResult.responseheader[data.h]).toBeStruct();
						}, data=data);
					} else {
						it(title="the response header #h# should be a simple/string value", body=function(data) {
							expect(data.boltResult.responseheader[data.h]).toBeString();
						}, data=data);
					}
					it(title="the response header #h# values should be equal", body=function(data) {
						expect(data.boltResult.responseheader[data.h]).toBe(data.cfResult.responseheader[data.h]);
						
					}, data=data);
				}

			}

			it(title="should have the same response headers", body=function(data) {
				expect(structKeyList(data.boltResult.responseheader)).toBe(structKeyList(data.cfResult.responseheader));
			}, data=data);			

		});
	}
}