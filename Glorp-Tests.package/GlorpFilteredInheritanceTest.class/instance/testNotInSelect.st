tests
testNotInSelect
	"Ask for an Employee which should be from the cache and which should return a Manager."

	| testEmployees |
	session beginTransaction.
	
	[session beginUnitOfWork.
	self writeTestHarness.
	session commitUnitOfWork.
	testEmployees := session read: GlorpManager
				where: [:each | each id notIn: #(1 2 3)].
	self assert: testEmployees notEmpty

	"Proxys seem to try a cache lookup before they execute their query...can we write a test which fails due to this?"] 
			ensure: [session rollbackTransaction]