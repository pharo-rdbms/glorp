mapping
mapObject: anObject inElementBuilder: anElementBuilder
	| myTraceNode myBuilder |
	"If the object already has a value in my slot, then this it got a cache hit, the embedded value was carried along for the ride, and we don't need to assign anything"
	(self getValueFrom: anObject) isNil ifFalse: [^self].	"Otherwise, we need to look up the trace node that corresponds to this mapping, and get its instance"
	myTraceNode := anElementBuilder expression get: self attributeName.
	myBuilder := anElementBuilder query elementBuilderFor: myTraceNode.
	self setValueIn: anObject to: myBuilder instance.