"
When mapping, if we encounter an object in a relationship that doesn't match the type we're expecting from the ClassModel/AttributeModel then we raise this exception. 

Instance Variables:
	expectedType	<GlorpClassModel>		The classModel for the type we were expecting.
	object	<Object>	The object that contained the invalid reference.


"
Class {
	#name : #GlorpInvalidTypeError,
	#superclass : #GlorpError,
	#instVars : [
		'object',
		'expectedType'
	],
	#category : 'Glorp-Exceptions'
}

{ #category : #accessing }
GlorpInvalidTypeError >> defaultMessageText [
	^'Object being written does not match the type of the attribute: ''', self object printString,  ''' ~= ''' , self expectedType printString, ''''.
]

{ #category : #accessing }
GlorpInvalidTypeError >> expectedType [
	^expectedType
]

{ #category : #accessing }
GlorpInvalidTypeError >> expectedType: aGlorpClassModel [
	expectedType := aGlorpClassModel
]

{ #category : #accessing }
GlorpInvalidTypeError >> object [
	^object
]

{ #category : #accessing }
GlorpInvalidTypeError >> object: anObject [
	object := anObject
]
