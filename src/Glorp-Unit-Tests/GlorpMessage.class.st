Class {
	#name : #GlorpMessage,
	#superclass : #Object,
	#instVars : [
		'folder',
		'user',
		'subject',
		'contents'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

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

{ #category : #initialization }
GlorpMessage >> initialize [

	super initialize.
	subject := ''.
	contents := ''
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
