tests
testRelationshipQuery
	"Ask for all Employees in a given office and test that the return types are correct."

	| employees office |
	session beginTransaction.
	
	[session beginUnitOfWork.
	self writeTestHarness.
	session commitUnitOfWork.
	session initializeCache.
	office := session readOneOf: GlorpOffice
				where: [:each | each id = 1 ].
	employees := office employees.
	self assert: employees size = 6.
	self assert: (employees select: [:emp | emp isMemberOf: GlorpEmployee]) size = 2.
	self assert: (employees select: [:emp | emp isMemberOf: GlorpManager]) size = 1.
	self assert: (employees select: [:emp | emp isMemberOf: GlorpLineWorker]) size = 2.
	self assert: (employees select: [:emp | emp isMemberOf: GlorpRegionalManager]) size = 1] 
			ensure: [session rollbackTransaction]