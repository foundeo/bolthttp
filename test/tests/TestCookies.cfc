component extends="testbox.system.BaseSpec" {

	//http://httpbin.org/

	function run(testResults, testBox) {
		
		describe("Test Response Cookies", function() {
			it("It should put multiple response cookies in a struct", function() {
				var bolt = new bolthttp.bolthttp();
				var result = bolt.request(url="http://httpbin.org/cookies/set?k2=v2&k1=v1", method="GET",options={redirect=false});
				expect(result.responseheader).toHaveKey("Set-Cookie");
				expect(result.responseHeader["Set-Cookie"]).toBeStruct("Set-Cookie in responseheader should be a struct");
				expect(result.responseheader["Set-Cookie"]).toHaveKey("1");
				expect(result.responseheader["Set-Cookie"]).toHaveKey("2");
				//not sure about ordering but make sure both values are there
				if (result.responseheader["Set-Cookie"]["1"] contains "k2") {
					expect(result.responseheader["Set-Cookie"]["1"]).toMatch("v2");
					expect(result.responseheader["Set-Cookie"]["2"]).toMatch("v1");
				} else {
					expect(result.responseheader["Set-Cookie"]["2"]).toMatch("v2");
					expect(result.responseheader["Set-Cookie"]["1"]).toMatch("v1");
				}
			});

			it("It should put single response cookies in a string", function() {
				var bolt = new bolthttp.bolthttp();
				var result = bolt.request(url="http://httpbin.org/cookies/set?k1=v1", method="GET", options={redirect=false});
				expect(result.responseheader).toHaveKey("Set-Cookie");
				expect(result.responseHeader["Set-Cookie"]).notToBeStruct("Set-Cookie in responseheader should not be a struct");
				expect(isSimpleValue(result.responseHeader["Set-Cookie"])).toBeTrue("Should be a simple value");
				expect(result.responseheader["Set-Cookie"]).toMatch("v1");
			});
		});


		describe("Test Request Cookies", function() {
			it("should send a cookie", function() {
				var bolt = new bolthttp.bolthttp();
				var result = bolt.request(url="http://httpbin.org/cookies", method="GET", params=[{type="cookie",name="myCookie",value="myValue"}]);
				var rObj = deserializeJSON(result.fileContent);
				expect(rObj.cookies).toHaveKey("myCookie");
				expect(rObj.cookies.myCookie).toBe("myValue");
			});

			it("should send multiple cookies", function() {
				var bolt = new bolthttp.bolthttp();
				var result = bolt.request(url="http://httpbin.org/cookies", method="GET", params=[{type="cookie",name="myCookie",value="myValue"}, {type="cookie",name="myOtherCookie",value="myOther/Value"}]);
				var rObj = deserializeJSON(result.fileContent);
				expect(rObj.cookies).toHaveKey("myCookie");
				expect(rObj.cookies).toHaveKey("myOtherCookie");
				expect(rObj.cookies.myCookie).toBe("myValue");
				expect(rObj.cookies.myOtherCookie).toBe("myOther/Value");
			});

		});



	}
}

