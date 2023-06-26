"
A gallery from the Gallery model
"
Class {
	#name : #GlorpGallery,
	#superclass : #Object,
	#instVars : [
		'id',
		'name',
		'images'
	],
	#category : #'Glorp-Unit-Tests-Models - Gallery'
}

{ #category : #accessing }
GlorpGallery >> id [

	^ id
]

{ #category : #accessing }
GlorpGallery >> id: anObject [

	id := anObject
]

{ #category : #accessing }
GlorpGallery >> images [

	^ images
]

{ #category : #accessing }
GlorpGallery >> images: anObject [

	images := anObject
]

{ #category : #initialization }
GlorpGallery >> initialize [

	super initialize.
	images := OrderedCollection new
]

{ #category : #accessing }
GlorpGallery >> name [

	^ name
]

{ #category : #accessing }
GlorpGallery >> name: anObject [

	name := anObject
]
