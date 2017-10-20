*Glorp
glorpPrintSQLOn: aCommand
	| platform requiresEscape |
	platform := [aCommand platform] on: MessageNotUnderstood do: [:ex | ex return: nil].
	aCommand nextPut: $'.
	1
		to: self size
		do:
			[:i | 
			| char |
			char := self at: i.
			requiresEscape := platform isNil ifTrue: [false] ifFalse: [platform requiresEscapeFor: char].
			requiresEscape
				ifTrue: [aCommand nextPutAll: (aCommand platform escapeFor: char)]
				ifFalse: [aCommand nextPut: char]].
	aCommand nextPut: $'.