"
Boolean type for MySQL platform. MySQL stores boolean as tinyint(1)
"
Class {
	#name : 'GlorpMySQLBooleanType',
	#superclass : 'GlorpBooleanType',
	#category : 'Glorp-Types',
	#package : 'Glorp',
	#tag : 'Types'
}

{ #category : 'converting' }
GlorpMySQLBooleanType >> converterForStType: aClass [
	(aClass includesBehavior: Boolean) ifTrue: [^self platform converterNamed: #booleanToInteger].
	^self platform nullConverter.
]
