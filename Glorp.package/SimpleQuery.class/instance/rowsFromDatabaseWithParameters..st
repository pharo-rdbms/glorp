executing
rowsFromDatabaseWithParameters: anArray

	| alreadyTriedAction command |
	(self shortCircuitEmptyReturn: anArray) ifTrue: [^session accessor cursorFor: (ReadStream on: #()) command: (self sqlWith: anArray)].
	alreadyTriedAction := false.
	command := self sqlWith: anArray.
	^[session accessor
		executeCommand: command
		returnCursor: true] 
	on: GlorpDatabaseReadError 
	do: [:ex | 
		alreadyTriedAction ifTrue: [ex pass] ifFalse: [alreadyTriedAction := true].
		session errorAction isNil 
			ifTrue: [ex pass] 
			ifFalse: [
				session errorAction value: ex value: session value: self.	
				ex retry]]