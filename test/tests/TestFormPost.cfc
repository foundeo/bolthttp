component extends="testbox.system.BaseSpec" {

	//http://httpbin.org/post

	function run(testResults, testBox) {
		

		describe("Test formfield POST", function() {
			it("It should post data", function() {
				var bolt = new bolthttp.bolthttp();
				var result = bolt.request(url="http://httpbin.org/post", method="POST", params=[{type="formfield",name="foo",value="moo"}]);
				var rObj = deserializeJSON(result.fileContent);
				expect(rObj.form.foo).toBe("moo");
				
			});

			

		});
	}
}
