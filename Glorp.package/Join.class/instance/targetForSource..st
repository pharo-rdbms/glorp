preparing
targetForSource: aField

	| index |
	index := sources indexOf: aField.
	index = 0 ifTrue: [^nil].
	^targets at: index.