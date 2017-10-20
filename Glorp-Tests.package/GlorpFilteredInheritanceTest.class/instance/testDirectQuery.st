tests
testDirectQuery
	"Ask for all Employees, see if we get subclasses too"

	| employees offices |
	session beginTransaction.
	
	[session beginUnitOfWork.
	self writeTestHarness.
	session commitUnitOfWork.
	session initializeCache.
	employees := true 
				ifTrue: [session read: GlorpEmployee where: [:each | each name = 'Bob']]
				ifFalse: [session halt read: GlorpEmployee].
	self assert: employees size = 8.
	self 
		assert: (employees select: [:emp | emp isMemberOf: GlorpEmployee]) size = 1.
	self assert: (employees select: [:emp | emp isMemberOf: GlorpManager]) size = 2.
	self 
		assert: (employees select: [:emp | emp isMemberOf: GlorpLineWorker]) size = 4.
	self 
		assert: (employees select: [:emp | emp isMemberOf: GlorpRegionalManager]) size 
				= 1.
	self compareEmployees: employees.
	session initializeCache.
	offices := session readOneOf: GlorpOffice
				where: [:each | each employeeOfMonth name = 'Bob'].	"There is no regional manager with id = 4 but we can ensure that the type info is getting into the query's key by asking for one and seeing that it doesn't exist"
	session initializeCache.
	self 
		assert: (session readOneOf: GlorpRegionalManager where: [:each | each id = 4]) 
				== nil] 
			ensure: [session rollbackTransaction]