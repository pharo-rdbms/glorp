Class {
	#name : #GlorpConstantValueInRelationshipTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'session',
		'system'
	],
	#category : 'Glorp-Tests-Database'
}

{ #category : #'as yet unclassified' }
GlorpConstantValueInRelationshipTest class >> resources [
	^Array with: GlorpDatabaseLoginResource with: GlorpDemoTablePopulatorResource.
]

{ #category : #support }
GlorpConstantValueInRelationshipTest >> idsFor: aCollection [

	^(aCollection collect: [:each | each id]) asSortedCollection asArray.
]

{ #category : #support }
GlorpConstantValueInRelationshipTest >> sampleWorker [

	| worker job3 |
	worker := GlorpWorker new.
	worker id: 1234.
	worker name: 'Some Worker'.
	worker pendingJobs add: (GlorpJob new id: 1; description: 'job 1').
	worker pendingJobs add: (GlorpJob new id: 2; description: 'job 2').
	worker finishedJobs add: (job3 := GlorpJob new id: 3; description: 'job 3').
	worker finishedJobs add: (GlorpJob new id: 4; description: 'job 4').
	worker priorityJobs add: job3.
	^worker.
]

{ #category : #support }
GlorpConstantValueInRelationshipTest >> setUp [
	system := GlorpWorkerDescriptorSystem forPlatform: GlorpDatabaseLoginResource defaultLogin database.
	session := GlorpSessionResource current newSession.
	session system: system.
]

{ #category : #tests }
GlorpConstantValueInRelationshipTest >> testRead [

	| worker |
	[session beginTransaction.
	self writeTestData.
	worker := session execute: (Query readOneOf: GlorpWorker where: [:each | each id = 1234]).

	self assert: (self idsFor: worker pendingJobs) = #(1 2).
	self assert: (self idsFor: worker finishedJobs) = #(3 4).
	self assert: (self idsFor: worker priorityJobs) = #(3).

	] ensure: [session rollbackTransaction].
]

{ #category : #tests }
GlorpConstantValueInRelationshipTest >> testReadWithJoin [
	| worker |
	[session beginTransaction.
	self writeTestData.
	worker := session
		execute:
			(Query readOneOf: GlorpWorker where: [:each | each pendingJobs id = 1]).
	self assert: worker id = 1234] ensure: [session rollbackTransaction].
]

{ #category : #tests }
GlorpConstantValueInRelationshipTest >> testWrite [

	| worker sampleWorker |
	[session beginTransaction.
	session beginUnitOfWork.
	sampleWorker := self sampleWorker.
	session register: sampleWorker.
	session commitUnitOfWork.
	session reset.
	worker := session execute: (Query readOneOf: GlorpWorker where: [:each | each id = 1234]).

	self assert: (self idsFor: worker pendingJobs) = #(1 2).
	self assert: (self idsFor: worker finishedJobs) = #(3 4).
	self assert: (self idsFor: worker priorityJobs) = #(3).

	] ensure: [session rollbackTransaction].
]

{ #category : #support }
GlorpConstantValueInRelationshipTest >> writeTestData [

	session writeRow: system exampleWorkerRow.
	session writeRow: (system exampleJobRow: 1 finished: false).
	session writeRow: (system exampleJobRow: 2 finished: false).
	session writeRow: (system exampleJobRow: 3 finished: true).
	session writeRow: (system exampleJobRow: 4 finished: true).
	session writeRow: system exampleLinkRow1.
	session writeRow: system exampleLinkRow2.
]
