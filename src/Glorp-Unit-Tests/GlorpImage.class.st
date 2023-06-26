Class {
	#name : #GlorpImage,
	#superclass : #GlorpTaggableObject,
	#instVars : [
		'id',
		'location'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #'instance creation' }
GlorpImage class >> fromStream: aStream [
	^ self new image: aStream
]

{ #category : #accessing }
GlorpImage >> location [
	^ location
]

{ #category : #accessing }
GlorpImage >> location: aLocation [
	location := aLocation
]
