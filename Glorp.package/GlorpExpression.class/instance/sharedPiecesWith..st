debugging
sharedPiecesWith: anExpression
	"Return a set of the pieces we share in common with anExpression. Mostly useful for debugging unwanted sharing, or the lack of wanted sharing. Note that this won't dive down into subselects."
	| myPieces shared |
	myPieces := Dialect identitySetClass new.
	shared := Dialect identitySetClass new.
	self do: [:each | myPieces add: each].
	anExpression do: [:each | (myPieces includes: each) ifTrue: [shared add: each]].
	^shared.