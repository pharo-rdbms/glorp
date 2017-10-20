logging
logCommand: aDatabaseCommand bound: aBoolean

	"Log the execution of a command"
	| string |
	self changed: #command: with: aDatabaseCommand.
	self logging ifFalse: [^self].
	string := aDatabaseCommand sqlString.
 	aBoolean ifTrue: [string := string , '  ' , aDatabaseCommand bindings printString].
	string size > 4000 ifTrue: [string := string copyFrom: 1 to: 4000].
	Transcript
		cr;
		show: string.