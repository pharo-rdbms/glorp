preparing
translateFields: anOrderedCollection 
	"Ugh. Unify these mechnisms"
	^super translateFields: (self mapping translateFields: anOrderedCollection).