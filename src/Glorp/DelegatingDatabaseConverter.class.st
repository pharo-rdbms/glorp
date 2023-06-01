"
This is a converter which delegates the conversion to methods on some other object, typically the database platform.

Instance Variables
	host	<Object>	The receiver of the methods specified by the selectors.
	dbToStSelector	<Symbol>	The symbol we perform when converting from database to object representation. Takes two arguments, the value, and the database type.
	stToDbSelector	<Symbol>	The symbol we perform when converting from object to database representation. Takes two arguments, the value, and the database type.


"
Class {
	#name : #DelegatingDatabaseConverter,
	#superclass : #DatabaseConverter,
	#instVars : [
		'host',
		'stToDbSelector',
		'dbToStSelector'
	],
	#category : #'Glorp-Database'
}

{ #category : #'*Glorp' }
DelegatingDatabaseConverter class >> hostedBy: anObject fromStToDb: stDbSelector fromDbToSt: dbStSelector [

	^super new
		hostedBy: anObject fromStToDb: stDbSelector fromDbToSt: dbStSelector
]

{ #category : #'*Glorp' }
DelegatingDatabaseConverter class >> named: aSymbol hostedBy: anObject fromStToDb: stDbSelector fromDbToSt: dbStSelector [
	^super new
		named: aSymbol
		hostedBy: anObject
		fromStToDb: stDbSelector
		fromDbToSt: dbStSelector.
]

{ #category : #converting }
DelegatingDatabaseConverter >> convert: anObject fromDatabaseRepresentationAs: aDatabaseType [ 
	^host perform: dbToStSelector with: anObject with: aDatabaseType
]

{ #category : #converting }
DelegatingDatabaseConverter >> convert: anObject toDatabaseRepresentationAs: aDatabaseType [ 
	^host perform: stToDbSelector with: anObject with: aDatabaseType.
]

{ #category : #initialization }
DelegatingDatabaseConverter >> hostedBy: anObject fromStToDb: stDbSelector fromDbToSt: dbStSelector [

	host := anObject.
	stToDbSelector := stDbSelector.
	dbToStSelector := dbStSelector
]

{ #category : #initialization }
DelegatingDatabaseConverter >> named: aSymbol hostedBy: anObject fromStToDb: stDbSelector fromDbToSt: dbStSelector [

	name := aSymbol.
	host := anObject.
	stToDbSelector := stDbSelector.
	dbToStSelector := dbStSelector
]
