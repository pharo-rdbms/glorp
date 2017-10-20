tests
testReadTransactionsWithIndependentSubselectAndNot
	| query result query2 matchingResult |
	
	[session beginTransaction.
	self write2CustomerRowsWith3Transactions.
	query := Query read: GlorpBankTransaction where: [:each |
		each notExists: (Query read: GlorpCustomer where: [:eachCustomer |
			(eachCustomer id = each owner id) & (eachCustomer name = 'anotherCustomer')])].
	query orderBy: [:each | each owner name].
	"Another way of saying the same thing"
	query2 := Query read: GlorpBankTransaction where: [:each | each owner name ~= 'anotherCustomer'].
	query2 orderBy: [:each | each owner name].
	result := session execute: query.
	matchingResult := session execute: query2.
	self assert: result size = matchingResult size.
	result with: matchingResult do: [:one :other |
		self assert: one = other]] 
			ensure: [session rollbackTransaction]