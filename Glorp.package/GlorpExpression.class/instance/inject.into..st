iterating
inject: anObject into: aBlock

	| sum |
	sum := anObject.
	self do: [:each | sum := aBlock value: sum value: each].
	^sum