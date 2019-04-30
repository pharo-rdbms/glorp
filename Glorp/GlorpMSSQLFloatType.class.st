"
MSSQL Float type 
"
Class {
	#name : #GlorpMSSQLFloatType,
	#superclass : #GlorpAbstractNumericType,
	#category : 'Glorp-Types'
}

{ #category : #SQL }
GlorpMSSQLFloatType >> converterForStType: aClass [

	^self platform converterNamed: #numberToDouble.
]

{ #category : #converting }
GlorpMSSQLFloatType >> impliedSmalltalkType [
	^Float.
]

{ #category : #initialize }
GlorpMSSQLFloatType >> initialize [
	super initialize.
	typeString := 'float'.
]

{ #category : #SQL }
GlorpMSSQLFloatType >> typeString [
	^'float'.
]
