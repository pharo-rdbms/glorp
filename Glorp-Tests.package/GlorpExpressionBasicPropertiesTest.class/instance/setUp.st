support
setUp

	base := BaseExpression new descriptor: (
		(GlorpDemoDescriptorSystem forPlatform: GlorpDatabaseLoginResource defaultLogin database)
			descriptorFor: GlorpPerson)