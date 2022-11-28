Class {
	#name : #GlorpGallery,
	#superclass : #Object,
	#instVars : [
		'id',
		'name',
		'images'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #'as yet unclassified' }
GlorpGallery class >> new [
	^super new initialize.
]

{ #category : #accessing }
GlorpGallery >> id [
	^id
]

{ #category : #accessing }
GlorpGallery >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GlorpGallery >> images [
	^images
]

{ #category : #accessing }
GlorpGallery >> images: anObject [
	images := anObject
]

{ #category : #'initialize-release' }
GlorpGallery >> initialize [
	images := OrderedCollection new.
]

{ #category : #accessing }
GlorpGallery >> name [
	^name
]

{ #category : #accessing }
GlorpGallery >> name: anObject [
	name := anObject
]
