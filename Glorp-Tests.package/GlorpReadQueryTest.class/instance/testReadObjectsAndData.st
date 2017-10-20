tests-data reading
testReadObjectsAndData

	| query result tracing addressReadSeparately personReadSeparately |
	query := Query read: GlorpPerson.
	tracing := Tracing new.
	tracing retrieve: [:each | each id].
	tracing retrieve: [:each | each address].
	query tracing: tracing.
	query orderBy: #id.
	result := query executeIn: session.
	self assert: result size = 3.
	self assert: (result first at: 1) = 86.
	self assert: ((result first at: 2) class == GlorpAddress).
	self assert: ((result first at: 2) id = 2).
	addressReadSeparately := session readOneOf: GlorpAddress where: [:each | each id = 2].
	self assert: result first last == addressReadSeparately.
	personReadSeparately := session readOneOf: GlorpPerson where: [:each | each id = 86].
	self assert: personReadSeparately address yourSelf == result first last.