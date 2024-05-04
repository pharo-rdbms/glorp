"
When querying for a dictionary, it's not enough to tell the query to return its collection in a dictionary. We need to be able to describe both the key and the value. So we would pass an instance of this as the collectionType: to a query or mapping.

Instance Variables:
	keyExpression	<GlorpExpression | Block>	The description of the key
	valueExpression	<GlorpExpression | Block>	The description of the value


"
Class {
	#name : 'GlorpDictionaryDescription',
	#superclass : 'Object',
	#instVars : [
		'keyExpression',
		'valueExpression'
	],
	#category : 'Glorp-Queries',
	#package : 'Glorp',
	#tag : 'Queries'
}

{ #category : 'instance creation' }
GlorpDictionaryDescription >> copyEmpty: anInteger [
	"Masquerade as a instance of a collection :-)"
	^Dictionary new: anInteger
]

{ #category : 'accessing' }
GlorpDictionaryDescription >> keyExpression [
	^keyExpression
]

{ #category : 'accessing' }
GlorpDictionaryDescription >> keyExpression: anExpression [
	keyExpression := anExpression
]

{ #category : 'instance creation' }
GlorpDictionaryDescription >> new [
	"Masquerade as a class"
	^Dictionary new
]

{ #category : 'instance creation' }
GlorpDictionaryDescription >> new: anInteger [
	"Masquerade as a class"
	^Dictionary new: anInteger
]

{ #category : 'accessing' }
GlorpDictionaryDescription >> valueExpression [
	^valueExpression
]

{ #category : 'accessing' }
GlorpDictionaryDescription >> valueExpression: anExpression [
	valueExpression := anExpression
]
