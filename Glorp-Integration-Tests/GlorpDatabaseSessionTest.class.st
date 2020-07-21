Class {
	#name : #GlorpDatabaseSessionTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'session'
	],
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #'as yet unclassified' }
GlorpDatabaseSessionTest class >> resources [

	^Array with: GlorpSessionResource.
]

{ #category : #support }
GlorpDatabaseSessionTest >> setUp [

	super setUp.
	session := GlorpSessionResource current newSession.
]

{ #category : #support }
GlorpDatabaseSessionTest >> tearDown [
	super tearDown.
	session reset.
	session := nil.
]

{ #category : #tests }
GlorpDatabaseSessionTest >> testWriteRow [
	| rowToWrite fields rowReadFromDatabase |
	rowToWrite := session system examplePersonRow2.
	
	[session beginTransaction.
	session writeRow: rowToWrite.
	rowReadFromDatabase := (session accessor
				executeSQLString: 'SELECT * FROM ' , rowToWrite table name) first.
	fields := rowToWrite table fields.
	(1 to: fields size) with: fields
		do: [:index :field | self assert: (rowReadFromDatabase atIndex: index) = (rowToWrite at: field)]] 
			ensure: [session rollbackTransaction]
]
