tests-data reading
testReadTwoDataItems

	| query result tracing|
	query := Query read: GlorpPerson.
	tracing := Tracing new.
	tracing retrieve: [:each | each id].
	tracing retrieve: [:each | each name].
	query tracing: tracing.
	result := query executeIn: session.
	self assert: result size = 3.
	self assert: (result includes: #(86 'person1')).
	self assert: (result includes: #(87 'person2')).
	self assert: (result includes: #(88 'person3')).