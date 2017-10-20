tests
testCacheLookup
	"Ask for an Employee which should be from the cache and which should return a Manager."

	| manager employee |
	session beginTransaction.
	
	[session beginUnitOfWork.
	self writeTestHarness.
	session commitUnitOfWork.
	session initializeCache.
	manager := session readOneOf: GlorpManager
				where: [:each | each id = 3 ].
	self assert: (session cacheLookupForClass: GlorpEmployee key: 3) == manager.
	employee := session readOneOf: GlorpEmployee
				where: [:each | each id = 3 ].
	self assert: employee == manager.

	manager := session readOneOf: GlorpRegionalManager
				where: [:each | each id = 12 ].
	employee := session readOneOf: GlorpEmployee
				where: [:each | each id = 12 ].
	self assert: employee == manager.

	employee := session readOneOf: GlorpManager
				where: [:each | each id = 11 ].
	manager := session readOneOf: GlorpEmployee
				where: [:each | each id = 11 ].
	self assert: employee == manager.

	"Test that the cache refuses to return an object which is not of the proper class or subclass."
	employee := session readOneOf: GlorpEmployee
				where: [:each | each id = 4 ].
	self assert: (session privateGetCache lookupClass: GlorpRegionalManager key: 4 ifAbsent: []) isNil.
	manager := session readOneOf: GlorpRegionalManager
				where: [:each | each id = 4 ].
	self assert: manager isNil.

	"Proxys seem to try a cache lookup before they execute their query...can we write a test which fails due to this?"] 
			ensure: [session rollbackTransaction]