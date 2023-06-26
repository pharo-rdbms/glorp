Class {
	#name : #GlorpEncyclopedia,
	#superclass : #Object,
	#instVars : [
		'id',
		'name',
		'entries',
		'biographicalEntries'
	],
	#category : #'Glorp-Unit-Tests-Models - Encyclopedia'
}

{ #category : #examples }
GlorpEncyclopedia class >> example1 [
	| result |
	result := GlorpEncyclopedia new.
	result entries at: 'one' put: GlorpEncyclopediaEntry example1.
	result entries at: 'two' put: GlorpEncyclopediaEntry example2.
	^result.
]

{ #category : #accessing }
GlorpEncyclopedia >> articleAt: aString put: anEntry [
	entries at: aString put: anEntry.
]

{ #category : #accessing }
GlorpEncyclopedia >> biographicalEntries [
	^biographicalEntries
]

{ #category : #accessing }
GlorpEncyclopedia >> biographicalEntries: aDictionary [
	biographicalEntries := aDictionary
]

{ #category : #accessing }
GlorpEncyclopedia >> entries [
	^entries.
]

{ #category : #accessing }
GlorpEncyclopedia >> entries: aDictionary [
	entries := aDictionary
]

{ #category : #accessing }
GlorpEncyclopedia >> id [
	^id
]

{ #category : #accessing }
GlorpEncyclopedia >> id: anInteger [
	id := anInteger
]

{ #category : #initialization }
GlorpEncyclopedia >> initialize [

	super initialize.
	entries := Dictionary new.
	biographicalEntries := Dictionary new
]

{ #category : #accessing }
GlorpEncyclopedia >> name [
	^name
]

{ #category : #accessing }
GlorpEncyclopedia >> name: aString [
	name := aString
]

{ #category : #accessing }
GlorpEncyclopedia >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	name isNil ifFalse: [aStream nextPutAll: name].
	aStream nextPut: $).
]
