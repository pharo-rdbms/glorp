tests-data reading
testReadTwoObjects

	| query result |
	query := Query read: GlorpPerson.
	query retrieve: [:each | each].
	query retrieve: [:each | each address].
	query orderBy: [:each | each id].
	result := query executeIn: session.
	self assert: result size = 3.
	self assert: (result first atIndex: 1) id = 86.
	self assert: ((result first atIndex: 1) address yourSelf == result first last).