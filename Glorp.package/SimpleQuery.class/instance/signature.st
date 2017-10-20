sql generation
signature
	session useBinding ifFalse: [^''].
	^self sqlWith: Dictionary new.