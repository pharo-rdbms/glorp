Class {
	#name : #GlorpUser,
	#superclass : #Object,
	#instVars : [
		'id',
		'name',
		'folders'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #accessing }
GlorpUser >> folders [
	^folders
]

{ #category : #accessing }
GlorpUser >> folders: aCollection [
	folders := aCollection
]

{ #category : #accessing }
GlorpUser >> id [
	^id
]

{ #category : #accessing }
GlorpUser >> id: anInteger [
	id := anInteger
]

{ #category : #'initialize-release' }
GlorpUser >> initialize [

	id := nil.
	folders := OrderedCollection new.
]

{ #category : #accessing }
GlorpUser >> name [
	^name.
]

{ #category : #accessing }
GlorpUser >> name: aString [
	name := aString.
]
