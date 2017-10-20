fields
translateFields: anOrderedCollection 
	^anOrderedCollection collect: [:each | self translateField: each]