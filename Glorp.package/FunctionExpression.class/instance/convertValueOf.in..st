iterating
convertValueOf: anObject in: aDictionary
	| translated |

	translated := anObject isGlorpExpression 
		ifTrue: [anObject valueIn: aDictionary]
		ifFalse: [anObject].
	translated isGlorpExpression ifTrue: [^translated].
	^self base convertedDbValueOf: translated.