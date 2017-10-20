iterating
convertValueOf: anObject in: aDictionary
	| translated convertedValue |

	translated := anObject isGlorpExpression 
		ifTrue: [anObject valueIn: aDictionary]
		ifFalse: [anObject].
	translated isGlorpExpression ifTrue: [^translated].
	convertedValue := self expectsCollectionArgument 
		ifTrue: [translated collect: [:each | self leftChild convertedDbValueOf: each]]
		ifFalse: [self leftChild convertedDbValueOf: translated].
	^convertedValue.