tests-subselect
testReadCustomerOrderingByCountSubselect
	"DB2 (as of 9.8) does not support an ORDER BY clause with correlated column references.	The ORDER BY sub-select here refers back to the selected column, so we skip this for DB2. Access doesn't appear to allow anything in the ORDER BY clause except column names."

	| customers |
	(session platform supportsCorrelatedSubqueriesInOrderBy) ifFalse: [^self].
	self
		inTransactionDo:
			[| sorted |
			self writeCustomerWithAccounts.
			customers := session
				read: GlorpCustomer
				orderBy: [:each | each accounts sqlCount].
			sorted := (customers asSortedCollection: [:a :b | a accounts size <= b accounts size]) asArray.
			self assert: customers = sorted.
			customers := session
				read: GlorpCustomer
				orderBy: [:each | each accounts sqlCount descending].
			self assert: customers reverse = sorted].