support
setUp
	| session |
	session := GlorpMockSession new.
	session beginUnitOfWork.
	unitOfWork := session privateGetCurrentUnitOfWork.
	session system: (GlorpDemoDescriptorSystem forPlatform: GlorpDatabaseLoginResource defaultLogin database)