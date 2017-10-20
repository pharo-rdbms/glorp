setup
glorpTestsSystem
	"We want to prep the GlorpDemoTablePopulatorResource but subclasses using different systems may not;  put it here where it will be overridden."

	GlorpDemoTablePopulatorResource current.
	^GlorpDemoDescriptorSystem forPlatform: GlorpDatabaseLoginResource defaultLogin database