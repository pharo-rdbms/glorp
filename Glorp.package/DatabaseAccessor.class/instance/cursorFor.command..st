cursors
cursorFor: answerStream command: aCommand
   aCommand needsRowCount ifTrue: [
		aCommand rowCount: (self platform supportsRowCount
									ifTrue: [answerStream rowCount]
									ifFalse: [1])].
	^aCommand isNil
		ifTrue: [self cursorFor: answerStream]
		ifFalse: [GlorpCursoredStream on: answerStream for: aCommand accessor: self].