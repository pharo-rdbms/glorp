Class {
	#name : #GlorpImageLink,
	#superclass : #Object,
	#instVars : [
		'id',
		'title',
		'thumbnailBits',
		'fullImage'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #accessing }
GlorpImageLink >> id [
	^id
]

{ #category : #accessing }
GlorpImageLink >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GlorpImageLink >> image [
	^fullImage
]

{ #category : #accessing }
GlorpImageLink >> image: anObject [
	fullImage := anObject
]

{ #category : #accessing }
GlorpImageLink >> thumbnailBits [
	^thumbnailBits
]

{ #category : #accessing }
GlorpImageLink >> thumbnailBits: anObject [
	thumbnailBits := anObject
]

{ #category : #accessing }
GlorpImageLink >> title [
	^title
]

{ #category : #accessing }
GlorpImageLink >> title: anObject [
	title := anObject
]
