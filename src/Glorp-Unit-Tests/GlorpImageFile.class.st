Class {
	#name : #GlorpImageFile,
	#superclass : #Object,
	#instVars : [
		'id',
		'title',
		'bits',
		'thumbnailBits'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #examples }
GlorpImageFile class >> example1 [
	^self new
		title: 'example1';
		bits: #[1 2 3 4 5].
]

{ #category : #examples }
GlorpImageFile class >> example2 [
	^self new
		title: 'example2';
		bits: #[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15].
]

{ #category : #accessing }
GlorpImageFile >> bits [
	^bits
]

{ #category : #accessing }
GlorpImageFile >> bits: anObject [
	bits := anObject
]

{ #category : #accessing }
GlorpImageFile >> id [
	^id
]

{ #category : #accessing }
GlorpImageFile >> id: anObject [
	id := anObject
]

{ #category : #testing }
GlorpImageFile >> isLarge [
	^bits size > 10.
]

{ #category : #testing }
GlorpImageFile >> thumbnailBits [
	thumbnailBits isNil ifTrue: [thumbnailBits := bits copyFrom: 1 to: 5].
	^thumbnailBits.
]

{ #category : #accessing }
GlorpImageFile >> thumbnailBits: aByteArray [
	thumbnailBits := aByteArray
]

{ #category : #accessing }
GlorpImageFile >> title [
	^title
]

{ #category : #accessing }
GlorpImageFile >> title: anObject [
	title := anObject
]
