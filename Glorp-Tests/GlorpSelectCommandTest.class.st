Class {
	#name : #GlorpSelectCommandTest,
	#superclass : #GlorpSessionBasedTest,
	#category : 'Glorp-Tests-Database'
}

{ #category : #tests }
GlorpSelectCommandTest >> testExecute [
	| command dict result string |
	dict := #('abc' 'Smalltalk').
	string := session useBinding
		ifTrue: ['SELECT ID FROM STUFF WHERE THING=? OR THING = ?']
		ifFalse:
			['SELECT ID FROM STUFF WHERE THING=''abc'' OR THING = ''Smalltalk'''].
	command := SQLStringSelectCommand
		sqlString: string
		parameters: dict
		useBinding: session useBinding
		session: session.
	result := session accessor executeCommand: command.
	self assert: result size = 2.
	self assert: result first first = 12.
	self assert: result last first = 113141.
]
