as yet unclassified
padToTwoDigits: anInteger

	| string |
	string := anInteger truncated printString.
	^string size = 1 ifTrue: ['0', string] ifFalse: [string].