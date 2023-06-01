"
This is a helper class used for printing collections of joins in the <expletive deleted> ANSI join syntax. This syntax wants us to embed all of the joins into the initial list of tables, so we have to come up with an order for printing that makes sure we get all the joins in properly. This is more complicated than you might think.

Instance Variables:
	availableTables	<(Collection of: DatabaseTable)>	Which are the tables that we plan to print.
	joinsToProcess	<(Collection of: Join)>	Which joins do we have to put in between those tables somehow or other.
	query	<Query>	What is the query in which we are printing all of this.


"
Class {
	#name : #JoinPrinter,
	#superclass : #Object,
	#instVars : [
		'joinsToProcess',
		'availableTables',
		'query'
	],
	#category : #'Glorp-Queries'
}

{ #category : #'instance creation' }
JoinPrinter class >> for: aQuery [
	^self new query: aQuery
]

{ #category : #accessing }
JoinPrinter >> allTables [
	^query tablesToPrint
]

{ #category : #printing }
JoinPrinter >> nextJoin [
	^joinsToProcess detect: [:eachJoinExpression |
		eachJoinExpression tablesForANSIJoin anySatisfy: [:eachTable |
			availableTables includes: eachTable]]
]

{ #category : #printing }
JoinPrinter >> printJoinsOn: aCommand [
	"This is pretty hideous. Figure out an order in which to print these stupid joins. As a bonus, they may be circular, so we may have to collapse joins together. And if we collapse, we can't print as we go because we don't know how many parentheses to add, so store them up and print them all at the end"
	| allJoins |
	joinsToProcess := query joins copy.
	availableTables := Set with: self rootTable.
	allJoins := OrderedCollection new.
	[joinsToProcess isEmpty] whileFalse: [
		| next nextTable allRelatedJoins fullJoin|
		next := self nextJoin.
		joinsToProcess remove: next.
		nextTable := next tableToJoinFrom: availableTables.
		allRelatedJoins := joinsToProcess select: [:each | (each tableToJoinFrom: availableTables) = nextTable].
		fullJoin := allRelatedJoins inject: next into: [:sum :each | sum AND: each].
		joinsToProcess removeAll: allRelatedJoins.
		allJoins add: (fullJoin->nextTable).
		availableTables addAll: (next tablesForANSIJoin)].
	allJoins size timesRepeat: [aCommand platform parenthesizeCommandsInCompoundQuery ifTrue: [aCommand nextPut: $(]].
	aCommand nextPutAll: self rootTable sqlTableName.
	allJoins do: [:each | 
		each key printForANSIJoinTo: each value on: aCommand.
		aCommand platform parenthesizeCommandsInCompoundQuery ifTrue: [aCommand nextPut: $)]].
	self printLeftoverTablesOn: aCommand
]

{ #category : #printing }
JoinPrinter >> printLeftoverTablesOn: aCommand [
	"Now there might be leftover tables whose joins were implied directly by the where clause"
	| leftOverTables |
	leftOverTables := self allTables asSet copy.
	availableTables do: [:each | leftOverTables remove: each ifAbsent: []].
	leftOverTables isEmpty ifFalse: [aCommand nextPutAll: ', '].
	GlorpHelper
		print: [:each | each sqlTableName]
		on: aCommand
		for: leftOverTables
		separatedBy: ', '
]

{ #category : #accessing }
JoinPrinter >> query: aQuery [
	query := aQuery.	
	self setUp
]

{ #category : #accessing }
JoinPrinter >> rootTable [
	"Pick a table to start with"
	^self allTables first
]

{ #category : #initialization }
JoinPrinter >> setUp [
	availableTables := Set new
]
