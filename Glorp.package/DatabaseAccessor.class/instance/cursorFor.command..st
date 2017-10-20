cursors
cursorFor: answerStream command: aCommand
	^aCommand isNil
		ifTrue: [self cursorFor: answerStream]
		ifFalse: [GlorpCursoredStream on: answerStream for: aCommand accessor: self].