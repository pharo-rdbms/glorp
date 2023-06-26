Class {
	#name : #InheritanceQueryTest,
	#superclass : #GlorpSessionBasedTest,
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #'utility - inner queries' }
InheritanceQueryTest >> queryForCustomerStation [
	| query |
	query := Query read: CustomerStation where:
		[:customerStation |
		customerStation successor anySatisfy:
			[:successor | successor id in: self queryForSuccessor]].
	query retrieve: [:customerStation | customerStation id].
	^query
]

{ #category : #'utility - inner queries' }
InheritanceQueryTest >> queryForFeederStation [
	| query |
	query := Query read: FeederStation where: [:feederStation | feederStation id in: #(1 2 3 4)].
	query retrieve: [:feederStation | feederStation id].
	^query
]

{ #category : #'utility - inner queries' }
InheritanceQueryTest >> queryForSuccessor [
	| query |
	query := Query read: Successor where:
		[:successor | successor successorFeeder id in: self queryForFeederStation].
	query retrieve: [:successor | successor id].
	^query
]

{ #category : #running }
InheritanceQueryTest >> setUp [

	super setUp.
	system := TESTDescriptorSystem forPlatform: session platform.
	session system: system
]

{ #category : #tests }
InheritanceQueryTest >> testInnerQueries [
	| query |
	query := self queryForCustomerStation.
	session execute: query.
]

{ #category : #tests }
InheritanceQueryTest >> testLocalInnerQueries [
	"The same as testInnerQueries, but with all the queries defined within the block (should run the same)."

	| query |
	query := Query read: CustomerStation where:
		[:customerStation |
		customerStation successor anySatisfy: 
			[:successor || query2 |
			query2 := Query read: Successor where: 
				[:successor1 || feederQuery |
				feederQuery := Query read: FeederStation where:
					[:feederStation | feederStation id in: #(1 2 3 4)].
				feederQuery retrieve: [:feederStation | feederStation id].
				successor1 successorFeeder id in: feederQuery].
			query2 retrieve: [:successor1 | successor1 id].
			successor id in: query2]].
	query retrieve: [:customerStation | customerStation id].
	session execute: query.
]

{ #category : #tests }
InheritanceQueryTest >> testSubSelectRebuild [
	| query |
	query := Query read: Station where: 
		[:station |
		station successor anySatisfy:
			[:successor |
			successor successorCustomer id = 1 OR: [successor successorFeeder id = 1]]].
	"session accessor logOnlyOn: Transcript."
	session execute: query.
	"query := query asFullQuery.
	query session: session.
	query setUpExpressions.
	query asSimpleQueryFor: CustomerStation"
]
