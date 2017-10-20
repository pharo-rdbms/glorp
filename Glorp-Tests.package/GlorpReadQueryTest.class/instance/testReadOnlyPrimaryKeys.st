tests-data reading
testReadOnlyPrimaryKeys

	| query result |
	query := Query read: GlorpPerson.
	query retrieve: [:each | each id].
	result := query executeIn: session.
	self assert: (result asSortedCollection asArray = #(86 87 88)).