preparing
sourceForTarget: aField

	| index |
	index := targets indexOf: aField.
	index = 0 ifTrue: [^nil].
	^sources at: index.