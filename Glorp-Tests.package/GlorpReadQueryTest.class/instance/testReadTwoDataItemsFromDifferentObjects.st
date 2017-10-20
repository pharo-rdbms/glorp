tests-data reading
testReadTwoDataItemsFromDifferentObjects

	| query result tracing|
	query := Query read: GlorpPerson.
	tracing := Tracing new.
	tracing retrieve: [:each | each id].
	tracing retrieve: [:each | each address street].
	query tracing: tracing.
	query orderBy: #id.
	result := query executeIn: session.
	self assert: result size = 3.
	self assert: result first = #(86 'Beta').
	self assert: (result at: 2) = #(87 'Gamma').
	self assert: result last = #(88 'Alpha').