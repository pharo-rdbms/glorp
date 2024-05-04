"
MSSQL Float type 
"
Class {
	#name : 'GlorpMSSQLFloatType',
	#superclass : 'GlorpAbstractNumericType',
	#category : 'Glorp-Types',
	#package : 'Glorp',
	#tag : 'Types'
}

{ #category : 'converting' }
GlorpMSSQLFloatType >> converterForStType: aClass [

	^self platform converterNamed: #numberToDouble.
]

{ #category : 'converting' }
GlorpMSSQLFloatType >> impliedSmalltalkType [
	^Float.
]

{ #category : 'initialization' }
GlorpMSSQLFloatType >> initialize [
	super initialize.
	typeString := 'float'.
]

{ #category : 'SQL' }
GlorpMSSQLFloatType >> typeString [
	^'float'.
]
