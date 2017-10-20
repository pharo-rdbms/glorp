hooks
fieldNameForAttributeName: aSymbol 
	attributeNameToFieldNameBlock isNil  
		ifTrue: [^super fieldNameForAttributeName: aSymbol].
	^attributeNameToFieldNameBlock value: aSymbol