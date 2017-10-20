tests
testDirectQuery2
	"Ask for all Employees, see if we get subclasses too"

	| employees |
	session beginTransaction.
	
	[session beginUnitOfWork.
	self writeTestHarness.
	session commitUnitOfWork.
	session initializeCache.
	employees := session read: GlorpEmployee.
	self assert: employees size = 12.
	self 
		assert: (employees select: [:emp | emp isMemberOf: GlorpEmployee]) size = 2.
	self assert: (employees select: [:emp | emp isMemberOf: GlorpManager]) size = 3.
	self 
		assert: (employees select: [:emp | emp isMemberOf: GlorpLineWorker]) size = 5.
	self 
		assert: (employees select: [:emp | emp isMemberOf: GlorpRegionalManager]) size 
				= 2.
] 
			ensure: [session rollbackTransaction]