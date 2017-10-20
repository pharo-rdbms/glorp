tests-subselect
testReadCustomerWithFilteredSubSelectToAccountsAndAggregate
	"Test with a filtered read to accounts, where we've used an aggregate function to find the customer with the maximum primary key for the given id"

	| query |
	((session system descriptorFor: GlorpCustomer) mappingForAttributeNamed: #accounts) useFilteredRead.
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			query := Query readOneOf: GlorpCustomer where: [:each |
				| q |
				q := Query read: GlorpCustomer where: [:eachPundle |
					eachPundle name = 'aCustomer'].
				q retrieve: [:x | x id max].
				each id = q].
			customer := session execute: query.
			self assert: customer name = 'aCustomer'.
			self assert: (customer accounts collect: [:each | each id]) asSortedCollection asArray = #(6 9874)].