tests-join
testReadCustomerOrderByLinkTableField

	| customers |
	self
		inTransactionDo:
			[self writeCustomerWithAccounts.
			customers := session read: GlorpCustomer.
			customers do: [:each | | sortedAccounts |
				sortedAccounts := each accounts asSortedCollection: [:a :b | a id <= b id].
				self assert: each accountsSortedById asArray = sortedAccounts asArray]].