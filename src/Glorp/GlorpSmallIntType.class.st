"
Small int type 
"
Class {
	#name : #GlorpSmallIntType,
	#superclass : #GlorpAbstractIntegerType,
	#category : #'Glorp-Types'
}

{ #category : #initialization }
GlorpSmallIntType >> initialize [
	super initialize.
	typeString := 'smallint'.
]
