"
Ensure that warning/error messages are raised by invalid acts in dictionary mappings.
"
Class {
	#name : #GlorpDictionaryMappingErrorTest,
	#superclass : #GlorpSessionBasedTest,
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #support }
GlorpDictionaryMappingErrorTest >> setUp [
	super setUp.
	session system: (GlorpEncyclopediaStockDescriptorSystem forPlatform: session platform).
	session beginTransaction.
]

{ #category : #support }
GlorpDictionaryMappingErrorTest >> tearDown [
	session rollbackTransaction.
	super tearDown.
]

{ #category : #running }
GlorpDictionaryMappingErrorTest >> testModifyLinkTableForcingKeyRaisesError [
	"Change link table rows, not either of the two class tables.  This test involves a MultiRowKeyMap as owner of the link table row, and will not throw an exception in RowMap>>collapseMatchingInsertsAndDeletesFor:."

	| publishers publisher |
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.
	publisher := session readOneOf: GlorpTinyPublisher where: [:each | each id = 1].
	
	[session inUnitOfWorkDo: 
			[session modify: publisher
				in: [publisher titlesWithNumberInStock at: 'Mastering ENVY/Developer' put: 123]]]
	on: Dialect error
	do: [:ex | ^self assert: (ex messageText ~= 'link table entry requiring update is only partially populated') description: 'Raised #collapseMatchingInsertsAndDeletesFor: error'].
	self assert: true description: 'No error raised'
]
