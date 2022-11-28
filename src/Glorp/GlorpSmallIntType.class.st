"
Small int type 
"
Class {
	#name : #GlorpSmallIntType,
	#superclass : #GlorpAbstractIntegerType,
	#category : 'Glorp-Types'
}

{ #category : #initialize }
GlorpSmallIntType >> initialize [
	super initialize.
	typeString := 'smallint'.
]
