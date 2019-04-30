Class {
	#name : #GlorpMessage,
	#superclass : #Object,
	#instVars : [
		'folder',
		'user',
		'subject',
		'contents'
	],
	#category : 'Glorp-Tests-Models'
}

{ #category : #'as yet unclassified' }
GlorpMessage class >> new [
	"Answer a newly created and initialized instance."

	^super new initialize
]

{ #category : #accessing }
GlorpMessage >> contents [
	^contents
]

{ #category : #accessing }
GlorpMessage >> contents: aString [
	contents := aString
]

{ #category : #accessing }
GlorpMessage >> folder [
	^folder
]

{ #category : #accessing }
GlorpMessage >> folder: aGlorpFolder [
	folder := aGlorpFolder
]

{ #category : #accessing }
GlorpMessage >> folderName [
	^self folder name.
]

{ #category : #'initialize-release' }
GlorpMessage >> initialize [
	folder := nil.
	user := nil.
	subject := ''.
	contents := ''.
]

{ #category : #accessing }
GlorpMessage >> subject [
	^subject
]

{ #category : #accessing }
GlorpMessage >> subject: aString [
	subject := aString
]

{ #category : #accessing }
GlorpMessage >> user [
	^user
]

{ #category : #accessing }
GlorpMessage >> user: aGlorpUser [
	user := aGlorpUser
]

{ #category : #accessing }
GlorpMessage >> userId [
	^self user id.
]
