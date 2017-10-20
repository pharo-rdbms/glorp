tests-data reading
testReadDistinctIds

	| query result |
	query := Query read: GlorpPerson.
	query retrieve: [:each | each id distinct].
	result := query executeIn: session.
	self assert: (result asSortedCollection asArray = #(86 87 88)).