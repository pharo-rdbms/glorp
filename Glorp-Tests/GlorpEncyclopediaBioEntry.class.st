Class {
	#name : #GlorpEncyclopediaBioEntry,
	#superclass : #Object,
	#instVars : [
		'owner',
		'title',
		'text'
	],
	#category : 'Glorp-Tests-Models'
}

{ #category : #'as yet unclassified' }
GlorpEncyclopediaBioEntry class >> new [
	^super new initialize.
]

{ #category : #'initialize-release' }
GlorpEncyclopediaBioEntry >> initialize [
]

{ #category : #accessing }
GlorpEncyclopediaBioEntry >> text [
	^text
]

{ #category : #accessing }
GlorpEncyclopediaBioEntry >> text: anObject [
	text := anObject
]

{ #category : #accessing }
GlorpEncyclopediaBioEntry >> title [
	^title
]

{ #category : #accessing }
GlorpEncyclopediaBioEntry >> title: anObject [
	title := anObject
]
