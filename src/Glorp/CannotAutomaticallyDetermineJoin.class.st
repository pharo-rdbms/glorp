"
When we create descriptors, Glorp will try to determine the join to use between two tables based on foreign key constraints, if it hasn't been specified explicitly. If we can't find any foreign key constraints, or if we find too many, and can't decide automatically which one to use, we raise this exception.

This is an exception raised when creating 
Instance Variables:
	constraints	<Array of: ForeignKeyConstraint>	The list of constraints we found.
	tables	<Collection of: DatabaseTable>	The two tables we were trying to find a join between.


"
Class {
	#name : #CannotAutomaticallyDetermineJoin,
	#superclass : #GlorpError,
	#instVars : [
		'constraints',
		'tables'
	],
	#category : #'Glorp-Exceptions'
}

{ #category : #accessing }
CannotAutomaticallyDetermineJoin >> constraints [

	constraints isNil ifTrue: [ constraints := #(  ) ].
	^ constraints
]

{ #category : #accessing }
CannotAutomaticallyDetermineJoin >> constraints: aCollection [

	constraints := aCollection
]

{ #category : #accessing }
CannotAutomaticallyDetermineJoin >> defaultMessageText [

	^ 'Cannot calculate the join automatically, not enough information.'
]

{ #category : #accessing }
CannotAutomaticallyDetermineJoin >> tables [

	^ tables
]

{ #category : #accessing }
CannotAutomaticallyDetermineJoin >> tables: databaseTables [

	tables := databaseTables
]
