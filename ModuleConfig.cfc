component {

    this.name = "bolthttp";
    this.author = "";
    this.webUrl = "https://github.com/foundeo/bolthttp";
    this.autoMapModels = false;
    this.cfmapping = "bolthttp";

    function configure() {
        binder.map( "bolthttp@bolthttp" )
            .to( "#moduleMapping#.bolthttp" )
            
    }
}
