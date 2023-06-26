Class {
	#name : #GlorpEncyclopediaBioEntry,
	#superclass : #Object,
	#instVars : [
		'owner',
		'title',
		'text'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

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
