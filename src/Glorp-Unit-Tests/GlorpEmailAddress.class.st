"
An e-mail address in the Bank model
"
Class {
	#name : #GlorpEmailAddress,
	#superclass : #Object,
	#instVars : [
		'id',
		'user',
		'host'
	],
	#category : #'Glorp-Unit-Tests-Models - Bank'
}

{ #category : #accessing }
GlorpEmailAddress >> host [

	^ host
]

{ #category : #accessing }
GlorpEmailAddress >> host: anObject [

	host := anObject
]

{ #category : #accessing }
GlorpEmailAddress >> id [

	^ id
]

{ #category : #accessing }
GlorpEmailAddress >> id: anInteger [

	id := anInteger
]

{ #category : #printing }
GlorpEmailAddress >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	self id printOn: aStream.
	aStream nextPut: $).
]

{ #category : #accessing }
GlorpEmailAddress >> user [

	^ user
]

{ #category : #accessing }
GlorpEmailAddress >> user: anObject [

	user := anObject
]
