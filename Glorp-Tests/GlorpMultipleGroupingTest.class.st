"
Previously, grouping in Glorp Queries only accepted a single expression. It is of course easy to write a multiple groupBy: that would return conflicting values for one of the returned fields.  (When run, this raises an error demanding omission or aggregation of that field.)  Except for this need for greater care in relating the query groupings to the data searched and the fields/aggregates requested for retrieval, multiple groupings are very like multiple orderings.  The facility has therefore been added.
"
Class {
	#name : #GlorpMultipleGroupingTest,
	#superclass : #GlorpSessionBasedTest,
	#category : 'Glorp-Tests-Database'
}

{ #category : #support }
GlorpMultipleGroupingTest >> setUp [
	"We beginTransaction to be already in transaction on entering #transact:, so #transact will not commit if the transaction succeeds;  instead, #tearDown will roll it back, clean for the next test run."

	super setUp.
	session system: GlorpLockingDescriptorSystem new.
	session beginTransaction.
	session transact:
		[session system example2 do:
			[:each | session register: each]].
]

{ #category : #support }
GlorpMultipleGroupingTest >> tearDown [
	session rollbackTransaction.
	super tearDown.
]

{ #category : #tests }
GlorpMultipleGroupingTest >> testDoubleGrouping [
	"This is a simple, single table/class test of using #groupBy: twice, retrieving an aggregate field and a count.  (It is of course easy to write a multiple groupBy: that would return conflicting values for one of the returned fields.  When such a miswritten query is run, it raises an error demanding omission of that field or aggregation of its values.)"

	| books query |
	query := Query read: GlorpBook.
	query retrieve: [:each | each copiesInStock sum].
	query retrieve: [:each | each countStar].
	query groupBy: [:each | each title].
	query groupBy: [:each | each version].
	query orderBy: [:each | each title].	"order result so easy to check in assert"
	books := session execute: query.
	self assert: books = #(#(4 2) #(7 2)).
]
