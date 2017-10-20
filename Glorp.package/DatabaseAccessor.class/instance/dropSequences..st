executing
dropSequences: anArray
	anArray
		do:
			[:each | 
			self
				dropSequence: each
				ifAbsent:
					[:ex | 
					Transcript show: (ex messageText ifNil: [ex printString]).
					ex return: nil]].