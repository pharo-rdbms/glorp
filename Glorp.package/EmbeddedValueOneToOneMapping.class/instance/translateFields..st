mapping
translateFields: anOrderedCollection 
	fieldTranslation isNil ifTrue: [^anOrderedCollection].
	^anOrderedCollection collect: [:each |
		fieldTranslation sourceForTarget: each].