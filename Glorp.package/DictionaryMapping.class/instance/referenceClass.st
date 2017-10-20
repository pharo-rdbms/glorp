accessing
referenceClass
	"Return ourselves as the reference class, as a sort of a proxy for what we really want, which is a primitive, and varies according to the relationship anyway. Note that we have stuffed in a descriptor in the system, with ourselves (this instance) as the class."
"	^self mapsSimpleObject ifTrue: [self] ifFalse: [super referenceClass]."
	^self