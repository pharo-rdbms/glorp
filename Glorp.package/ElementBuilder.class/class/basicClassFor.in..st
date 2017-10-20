*Glorp
basicClassFor: anExpression in: aQuery

	^(anExpression hasDescriptor and: [anExpression mapsSimpleObject not])
		ifTrue: [ObjectBuilder] 
		ifFalse: [DataElementBuilder].