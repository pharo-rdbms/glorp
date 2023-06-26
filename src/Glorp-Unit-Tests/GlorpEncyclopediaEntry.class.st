"
An encyclopedia entry in the Encyclopedia mode
"
Class {
	#name : #GlorpEncyclopediaEntry,
	#superclass : #Object,
	#instVars : [
		'id',
		'text',
		'title',
		'mediaType'
	],
	#category : #'Glorp-Unit-Tests-Models - Encyclopedia'
}

{ #category : #examples }
GlorpEncyclopediaEntry class >> example1 [
	^self new
		id: 1;
		name: 'One';
		text: 'The first number (not counting zero)'.
]

{ #category : #examples }
GlorpEncyclopediaEntry class >> example2 [
	^self new
		id: 2;
		name: 'Two';
		text: 'The second number (comes after 1)'.
]

{ #category : #accessing }
GlorpEncyclopediaEntry >> id [

	^ id
]

{ #category : #accessing }
GlorpEncyclopediaEntry >> id: aSmallInteger [

	id := aSmallInteger
]

{ #category : #initialization }
GlorpEncyclopediaEntry >> initialize [

	super initialize.
	mediaType := GlorpMediaType text
]

{ #category : #accessing }
GlorpEncyclopediaEntry >> mediaType [

	^ mediaType
]

{ #category : #accessing }
GlorpEncyclopediaEntry >> mediaType: anObject [

	mediaType := anObject
]

{ #category : #printing }
GlorpEncyclopediaEntry >> printOn: aStream [

	super printOn: aStream.
	aStream nextPut: $(.
	title ifNotNil: [ aStream nextPutAll: title ].
	aStream nextPut: $)
]

{ #category : #accessing }
GlorpEncyclopediaEntry >> text [

	^ text
]

{ #category : #accessing }
GlorpEncyclopediaEntry >> text: aString [

	text := aString
]

{ #category : #accessing }
GlorpEncyclopediaEntry >> title [

	^ title
]

{ #category : #accessing }
GlorpEncyclopediaEntry >> title: aString [

	title := aString
]
