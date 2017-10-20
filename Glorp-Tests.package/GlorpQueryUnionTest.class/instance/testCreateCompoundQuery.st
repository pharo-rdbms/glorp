tests-unit
testCreateCompoundQuery
	| query1 union |
	query1 := Query read: GlorpAddress.
	union := query1 unionAll: query1.
	self assert: union class == CompoundQuery.