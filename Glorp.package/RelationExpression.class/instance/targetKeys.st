As yet unclassified
targetKeys
	"Assume that part of us is a join, and the rest doesn't count"
	^self inject: OrderedCollection new into: [:sum :each |
		each isJoin ifTrue: [sum addAll: each targetKeys].
		sum].