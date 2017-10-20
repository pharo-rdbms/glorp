as yet unclassified
padToThreeDigits: anInteger

	| string |
	string := anInteger truncated printString.
	string size = 3 ifTrue: [^string].
	string size = 2 ifTrue: [^'0', string].
	string size = 1 ifTrue: [^'00', string].
	^string