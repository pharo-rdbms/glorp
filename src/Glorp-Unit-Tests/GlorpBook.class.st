Class {
	#name : #GlorpBook,
	#superclass : #Object,
	#instVars : [
		'id',
		'description',
		'copiesInStock',
		'version',
		'title',
		'author'
	],
	#category : #'Glorp-Unit-Tests-Models - Bookstore'
}

{ #category : #examples }
GlorpBook class >> example1 [
	"These examples have some shared values to assist in testing groupBy."

	^(GlorpBook new)
		title: 'The First Book';
		author: 'John Doe';
		description: 'A good start';
		copiesInStock: 3;
		version: 1.
]

{ #category : #examples }
GlorpBook class >> example2 [
	"These examples have some shared values to assist in testing groupBy."

	^(GlorpBook new)
		title: 'The Second Book';
		author: 'John Doe';
		description: 'A superb book';
		copiesInStock: 2;
		version: 2.
]

{ #category : #examples }
GlorpBook class >> example3 [
	"These examples have some shared values to assist in testing groupBy."

	^(GlorpBook new)
		title: 'The First Book';
		author: 'Richard Roe';
		description: 'A good start';
		copiesInStock: 1;
		version: 1.
]

{ #category : #examples }
GlorpBook class >> example4 [
	"These examples have some shared values to assist in testing groupBy."

	^(GlorpBook new)
		title: 'The Second Book';
		author: 'Richard Roe';
		description: 'A superb book';
		copiesInStock: 5;
		version: 2.
]

{ #category : #accessing }
GlorpBook >> author [
	^author
]

{ #category : #accessing }
GlorpBook >> author: aString [
	author := aString
]

{ #category : #accessing }
GlorpBook >> copiesInStock [
	^copiesInStock
]

{ #category : #accessing }
GlorpBook >> copiesInStock: anInteger [
	copiesInStock := anInteger
]

{ #category : #accessing }
GlorpBook >> description [
	^description
]

{ #category : #accessing }
GlorpBook >> description: aString [
	description := aString
]

{ #category : #accessing }
GlorpBook >> id [
	^id
]

{ #category : #accessing }
GlorpBook >> id: anInteger [
	id := anInteger
]

{ #category : #accessing }
GlorpBook >> title [
	^title
]

{ #category : #accessing }
GlorpBook >> title: aString [
	title := aString.
]

{ #category : #accessing }
GlorpBook >> version [
	^version
]

{ #category : #accessing }
GlorpBook >> version: anInteger [
	version := anInteger
]
