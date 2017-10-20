tests-data reading
testReadDistinctIdsWithWhereClause

	| query result |
	query := Query read: GlorpPerson.
	query retrieve: [:each | each id distinct].
	query whereClause: [:each | each id ~= 423421].
	result := query executeIn: session.
	self assert: (result asSortedCollection asArray = #(86 87 88)).