tests
testReadMultipleObjectsManyToMany4
	"If we read just a to-many relation, then it doesn't get knitted and we just get a collection of the target"
	| query result |
	
	[session beginTransaction.
	self writeCustomer1Rows.

	query := Query read: GlorpCustomer where: [:each | each id ~= 7].
	query retrieve: [:each | each accounts].
	result := query executeIn: session.
	self assert: result size = 2.
	self assert: session privateGetCache numberOfElements = 2.
	self assert: (result allSatisfy: [:each | each class == GlorpBankAccount]).
	self assert: result first ~= result last] 
			ensure: [session rollbackTransaction]