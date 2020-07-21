Class {
	#name : #GlorpImage,
	#superclass : #GlorpTaggableObject,
	#instVars : [
		'id',
		'location'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #'as yet unclassified' }
GlorpImage class >> fromStream: aStream [
	^ self new image: aStream
]

{ #category : #'as yet unclassified' }
GlorpImage >> location [
	^ location
]

{ #category : #'as yet unclassified' }
GlorpImage >> location: aLocation [
	location := aLocation
]
