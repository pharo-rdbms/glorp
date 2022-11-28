"
This is a superclass for objects that convert back and forth between database representations and object representations.

Subclasses must implement the following messages:
	converting
		convert:fromDatabaseRepresentationAs:
		convert:toDatabaseRepresentationAs:

Instance Variables:
	name	<ByteSymbol>	The name for this converter. The name is used, concatenated with #Converter, to create a symbol that can be performed against the DatabasePlatform to give this converter. So, e.g. booleanToIntegerConverter.


"
Class {
	#name : #DatabaseConverter,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : 'Glorp-Database'
}

{ #category : #'*Glorp' }
DatabaseConverter class >> new [

	^super new initialize.
]

{ #category : #converting }
DatabaseConverter >> convert: anObject fromDatabaseRepresentationAs: aDatabaseType [ 
	self subclassResponsibility
]

{ #category : #converting }
DatabaseConverter >> convert: anObject toDatabaseRepresentationAs: aDatabaseType [ 
	self subclassResponsibility
]

{ #category : #initialize }
DatabaseConverter >> initialize [
	name := #unnamed.
]

{ #category : #accessing }
DatabaseConverter >> name [
	^name.
]

{ #category : #accessing }
DatabaseConverter >> name: aString [
	name := aString.
]

{ #category : #printing }
DatabaseConverter >> printOn: aString [
	aString nextPutAll: 'DatabaseConverter(', name, ')'.
]
