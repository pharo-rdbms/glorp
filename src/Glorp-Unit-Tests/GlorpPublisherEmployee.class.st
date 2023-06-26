Class {
	#name : #GlorpPublisherEmployee,
	#superclass : #Object,
	#instVars : [
		'id',
		'name',
		'jobTitle'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #accessing }
GlorpPublisherEmployee >> id [
	^id
]

{ #category : #accessing }
GlorpPublisherEmployee >> id: anObject [
	id := anObject
]

{ #category : #'initialize-release' }
GlorpPublisherEmployee >> initialize [
	"Initialize a newly created instance. This method must answer the receiver."

	" *** Edit the following to properly initialize instance variables ***"
	id := nil.
	name := nil.
	jobTitle := nil.
	" *** And replace this comment with additional initialization code *** "
	^self
]

{ #category : #accessing }
GlorpPublisherEmployee >> jobTitle [
	^jobTitle
]

{ #category : #accessing }
GlorpPublisherEmployee >> jobTitle: aString [
	jobTitle := aString
]

{ #category : #accessing }
GlorpPublisherEmployee >> name [
	^name
]

{ #category : #accessing }
GlorpPublisherEmployee >> name: anObject [
	name := anObject
]
