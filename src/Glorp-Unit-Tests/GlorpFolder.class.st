Class {
	#name : #GlorpFolder,
	#superclass : #Object,
	#instVars : [
		'user',
		'name',
		'messages'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #'initialize-release' }
GlorpFolder >> initialize [
	user := nil.
	messages := OrderedCollection new.
]

{ #category : #accessing }
GlorpFolder >> messages [
	^messages
]

{ #category : #accessing }
GlorpFolder >> messages: aCollection [
	messages := aCollection
]

{ #category : #accessing }
GlorpFolder >> name [
	^name.
]

{ #category : #accessing }
GlorpFolder >> name: aString [
	name := aString.
]

{ #category : #accessing }
GlorpFolder >> user [
	^user
]

{ #category : #accessing }
GlorpFolder >> user: aGlorpUser [
	user := aGlorpUser
]

{ #category : #accessing }
GlorpFolder >> userId [
	^self user id.
]
