"
Small int type 
"
Class {
	#name : 'GlorpSmallIntType',
	#superclass : 'GlorpAbstractIntegerType',
	#category : 'Glorp-Types',
	#package : 'Glorp',
	#tag : 'Types'
}

{ #category : 'initialization' }
GlorpSmallIntType >> initialize [
	super initialize.
	typeString := 'smallint'.
]
