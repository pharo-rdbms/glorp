"
A media type in the Encyclopedia mode
"
Class {
	#name : #GlorpMediaType,
	#superclass : #Object,
	#instVars : [
		'name',
		'mimeType'
	],
	#category : #'Glorp-Unit-Tests-Models - Encyclopedia'
}

{ #category : #accessing }
GlorpMediaType class >> text [

	^ self new
		  name: 'text';
		  mimeType: 'text/plain';
		  yourself
]

{ #category : #accessing }
GlorpMediaType >> mimeType [

	^ mimeType
]

{ #category : #accessing }
GlorpMediaType >> mimeType: anObject [

	mimeType := anObject
]

{ #category : #accessing }
GlorpMediaType >> name [

	^ name
]

{ #category : #accessing }
GlorpMediaType >> name: anObject [

	name := anObject
]
