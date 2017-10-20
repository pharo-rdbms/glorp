tests
testReadMultipleObjects

	| query result tracing addressReadSeparately personReadSeparately allResults |
	query := Query read: GlorpPerson.
	tracing := Tracing new.
	tracing retrieve: [:each | each ].
	tracing retrieve: [:each | each address].
	query tracing: tracing.
	query orderBy: #id.
	allResults := query executeIn: session.
	self assert: allResults size = 3.
	result := allResults first.
	self assert: (result at: 1) id = 86.
	self assert: ((result at: 1) class == GlorpPerson).
	self assert: (result at: 1) address == (result at: 2).
	self assert: ((result at: 2) class == GlorpAddress).
	self assert: ((result at: 2) id = 2).
	addressReadSeparately := session readOneOf: GlorpAddress where: [:each | each id = 2].
	self assert: result last == addressReadSeparately.
	personReadSeparately := session readOneOf: GlorpPerson where: [:each | each id = 86].
	self assert: personReadSeparately == result first.
	self assert: personReadSeparately address yourSelf == result last.