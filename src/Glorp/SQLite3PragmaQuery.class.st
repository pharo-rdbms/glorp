"
This is a query intended to execute a SQLite3 PRAGMA command. The command behaves like a stored function that takes a parameter and returns a result set. The meta information schema for SQLite is not available in the standard views, but it can be eventually deduced by executing particular pragma commands.

"
Class {
	#name : 'SQLite3PragmaQuery',
	#superclass : 'SimpleQuery',
	#category : 'Glorp-Queries',
	#package : 'Glorp',
	#tag : 'Queries'
}

{ #category : '*Glorp' }
SQLite3PragmaQuery class >> newQuery [
	^SQLite3PragmaQuery new
	"^super newQuery"
]

{ #category : 'sql generation' }
SQLite3PragmaQuery >> printWhereClauseOn: aCommand [

	self hasEmptyWhereClause
		ifFalse: 
			[whereClause rightChild printSQLOn: aCommand withParameters: aCommand parameters]
]

{ #category : 'sql generation' }
SQLite3PragmaQuery >> sqlWith: aDictionary [
	| result |
	self prepare.
	customCommand isNil ifFalse: [
		result := customCommand copy.
		result query: self; parameters: aDictionary; useBinding: session useBinding; session: session.
		^result].
	^SQLite3PragmaCommand
		forQuery: self
		parameters: aDictionary
		useBinding: session useBinding
		session: session
]
