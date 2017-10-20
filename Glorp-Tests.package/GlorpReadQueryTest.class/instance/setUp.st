support
setUp

	super setUp.
	session := GlorpSessionResource current newSession.
	session system: (GlorpDemoDescriptorSystem forPlatform: GlorpDatabaseLoginResource defaultLogin database).
	session beginTransaction.
	self writeAddressDoubleOrderingRows.
	self writePersonOrderingRows.