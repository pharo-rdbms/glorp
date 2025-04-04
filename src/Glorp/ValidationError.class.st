"
ValidationError is a superclass for all errors that are raise while validating a descriptor. The exception may resume.


"
Class {
	#name : #ValidationError,
	#superclass : #GlorpError,
	#category : #'Glorp-Exceptions'
}

{ #category : #accessing }
ValidationError class >> mayResume [

	^ true
]

{ #category : #accessing }
ValidationError >> description [

	^ self messageText
]

{ #category : #accessing }
ValidationError >> model [

	^ self parameter
]

{ #category : #accessing }
ValidationError >> model: aClass [

	self parameter: aClass
]
