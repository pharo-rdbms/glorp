Class {
	#name : #GlorpDictionaryMappingTest,
	#superclass : #GlorpSessionBasedTest,
	#category : 'Glorp-Tests-Tests'
}

{ #category : #support }
GlorpDictionaryMappingTest >> setUp [
	super setUp.
	session system: (GlorpEncyclopediaDescriptorSystem forPlatform: session platform).
	session beginTransaction.
]

{ #category : #support }
GlorpDictionaryMappingTest >> tearDown [
	session rollbackTransaction.
	super tearDown.
]

{ #category : #tests }
GlorpDictionaryMappingTest >> testCasesToWrite [

	"How des a dictionary mapping relate to 1:many vs many:many.
	dictionary of strings to strings
	dictionary of strings to objects
	dictionary of objects to objects
	keys always have to be related to values somehow, because I can't extract the association otherwise. Both might also be associated to source.
    You should be able to use the topological sort to determine the create/delete order of tables as well"
]

{ #category : #tests }
GlorpDictionaryMappingTest >> testCollectionKeyQuery [

	| encyclopedias matches |
	encyclopedias := session system exampleEncyclopedias.
	session transact: [session register: encyclopedias].
	session reset.
"	matches := session read: GlorpEncyclopedia	 where: [:each | each entries anySatisfy: [:eachEntry |
		((eachEntry getTable: 'ENCYC_ENTRY_LINK') getField: 'REFERENCE_NO') = 'unique']]."
	matches := session read: GlorpEncyclopedia	 where: [:each | each entries anySatisfy: [:eachEntry |
		eachEntry key = 'unique']].
	self assert: matches size = 1.
	self assert: matches first name = 'The Canadian Encyclopedia'.
	matches do: [:each | self assert: (each entries anySatisfy: [:eachEntry | eachEntry id = 'three'])].
	matches do: [:each | self assert: each entries size = 3].
]

{ #category : #tests }
GlorpDictionaryMappingTest >> testCollectionValueQuery [

	| encyclopedias matches |
	encyclopedias := session system exampleEncyclopedias.
	session transact: [session register: encyclopedias].
	session reset.
	matches := session read: GlorpEncyclopedia where: [:each | each entries anySatisfy: [:eachEntry |
		eachEntry value title = 'Vehicular Fish Decay']].
	self assert: matches size = 1.
	self assert: matches first name = 'The Canadian Encyclopedia'.
	matches do: [:each | self assert: (each entries anySatisfy: [:eachEntry | eachEntry id = 'three'])].
	matches do: [:each | self assert: each entries size = 3].
]

{ #category : #tests }
GlorpDictionaryMappingTest >> testCollectionValueQueryWithImpliedValue [

	| encyclopedias matches |
	encyclopedias := session system exampleEncyclopedias.
	session transact: [session register: encyclopedias].
	session reset.
	matches := session read: GlorpEncyclopedia where: [:each | each entries anySatisfy: [:eachEntry |
		eachEntry title = 'Vehicular Fish Decay']].
	self assert: matches size = 1.
	self assert: matches first name = 'The Canadian Encyclopedia'.
	matches do: [:each | self assert: (each entries anySatisfy: [:eachEntry | eachEntry id = 'three'])].
	matches do: [:each | self assert: each entries size = 3].
]

{ #category : #tests }
GlorpDictionaryMappingTest >> testCollectionValueQueryWithImpliedValueAndObjectEquality [

	| encyclopedias matches entry |
	encyclopedias := session system exampleEncyclopedias.
	session transact: [session register: encyclopedias].
	session reset.
	entry := session readOneOf: GlorpEncyclopediaEntry where: [:each | each title = 'Vehicular Fish Decay'].
	matches := session read: GlorpEncyclopedia where: [:each | each entries anySatisfy: [:eachEntry |
		eachEntry = entry]].
	self assert: matches size = 1.
	self assert: matches first name = 'The Canadian Encyclopedia'.
	matches do: [:each | self assert: (each entries anySatisfy: [:eachEntry | eachEntry id = 'three'])].
	matches do: [:each | self assert: each entries size = 3].
]

{ #category : #'tests-simple reference classes' }
GlorpDictionaryMappingTest >> testDeleteSimpleTypeOneToMany [
	| publishers publisher |
	self assert: (session read: GlorpPublisher) isEmpty.
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.
	publisher := session readOneOf: GlorpPublisher where: [:each | each id = 1].
	session modify: publisher in: [
		publisher titles: (publisher titles copyWithout: 'Mastering ENVY/Developer')].
	session reset.
	publisher := session readOneOf: GlorpPublisher where: [:each | each id = 1].
	self assert: publisher titles size = 2.
	self assert: publisher titles asSortedCollection = (session system examplePublisher1 titles copyWithout: 'Mastering ENVY/Developer') asSortedCollection.
]

{ #category : #tests }
GlorpDictionaryMappingTest >> testQueryWithDictionaryType [

	| encyclopedias query dict linkTable entryTable refField linkTableField idField |
	encyclopedias := session system exampleEncyclopedias.
	session transact: [session register: encyclopedias].
	session reset.
	linkTable := session system tableNamed: 'ENCYC_ENTRY_LINK'.
	entryTable := session system tableNamed: 'ENCYC_ENTRY'.
	refField := linkTable fieldNamed: 'REFERENCE_NO'.
	linkTableField := linkTable fieldNamed: 'ENCYC_ENTRY_ID'.
	idField := entryTable fieldNamed: 'ID'.
	query := Query read: GlorpEncyclopediaEntry.
	query where: [:each | ((each getTable: linkTable) getField: linkTableField) = ((each getTable: entryTable) getField: idField)].
	query retrieveDictionaryWithKey: [:each | (each getTable: linkTable) getField: refField] value: [:each | each].
	dict := session execute: query.
	self assert: dict class == Dictionary.
	self assert: dict size = 5.
	self assert: (dict at: 'abcde') id = 'two'.
	self assert: (dict at: 'abcde') == (dict at: 'edcba').
]

{ #category : #tests }
GlorpDictionaryMappingTest >> testReadWithAlsoFetch [
	| encyclopedias query readBackEncyclopedias |
	encyclopedias := session system exampleEncyclopedias.
	session transact: [session register: encyclopedias].
	session reset.
	query := Query read: GlorpEncyclopedia.
	query orderBy: [:each | each name].
	query alsoFetch: [:each | each entries asOuterJoin].
	readBackEncyclopedias := session execute: query.
	session accessor denyReads.
	self verifyEncyclopedias: readBackEncyclopedias.
]

{ #category : #tests }
GlorpDictionaryMappingTest >> testReadWithRetrieve [
	| encyclopedias query readBackEncyclopedias |
	encyclopedias := session system exampleEncyclopedias.
	session transact: [session register: encyclopedias].
	session reset.
	query := Query read: GlorpEncyclopedia.
	query orderBy: [:each | each name].
	query retrieve: [:each | each].
	query retrieve: [:each | each entries asOuterJoin].
	readBackEncyclopedias := session execute: query.
	session accessor denyReads.
	self assert: readBackEncyclopedias size = 6.
	self verifyEncyclopedias: ((readBackEncyclopedias collect: [:each | each first]) asSet asSortedCollection: [:a :b | a name <= b name]).
	readBackEncyclopedias do: [:eachArray |
		eachArray last key isNil 
			ifTrue: [self assert: eachArray first entries isEmpty]
			ifFalse: [self assert: (eachArray first entries at: eachArray last key) = eachArray last value]].
]

{ #category : #'tests-simple reference dictionary' }
GlorpDictionaryMappingTest >> testSimpleTypeDictionary [
	| publishers |
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.
	publishers := session read: GlorpPublisher where: [:each | each id = 1].
	publishers do: [:each | 
		each titlesWithNumberInStock keysAndValuesDo: [:eachTitle :eachNumber | 	
			self assert: eachTitle isString.
			self assert: eachNumber = 2]].
	self assert: publishers first titlesWithNumberInStock size = 3.
	self assert: publishers first titlesWithNumberInStock keys asSortedCollection = session system examplePublisher1 titles asSortedCollection.

"	publishers do: [:each | 
		each titlesWithNumberInStockLink keysAndValuesDo: [:eachTitle :eachNumber | 	
			self assert: eachTitle isString.
			self assert: eachNumber = 2]].
	self assert: publishers first titlesWithNumberInStockLink size = 3.
	self assert: publishers first titlesWithNumberInStockLink keys asSortedCollection = session system examplePublisher1 titles asSortedCollection."
]

{ #category : #'tests-simple reference dictionary' }
GlorpDictionaryMappingTest >> testSimpleTypeDictionaryComplexQuerying [
	| publishers |
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.
	publishers := session read: GlorpPublisher where: [:each | each titlesWithNumberInStock sqlCount = 3].
	self assert: publishers size = 1.
	self assert: publishers first titlesWithNumberInStock size = 3.
	self assert: (publishers first titlesWithNumberInStock keys includes: 'Mastering ENVY/Developer').

"	publishers := session read: GlorpPublisher where: [:each | each titlesWithNumberInStockLink sqlCount > 0].
	publishers := publishers asSortedCollection: [:a :b | a name <= b name].
	self assert: publishers size = 2.
	self assert: publishers first titlesWithNumberInStock size = 3.
	self assert: (publishers first titlesWithNumberInStock keys includes: 'Mastering ENVY/Developer')."
]

{ #category : #'tests-simple reference dictionary' }
GlorpDictionaryMappingTest >> testSimpleTypeDictionaryQuerying [
	| publishers |
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.

	publishers := session read: GlorpPublisher where: [:each | each titlesWithNumberInStock anySatisfy: [:x | x key like: 'Master%']].
	self assert: publishers size = 1.
	self assert: publishers first titlesWithNumberInStock size = 3.
	self assert: (publishers first titlesWithNumberInStock keys includes: 'Mastering ENVY/Developer').

"	publishers := session read: GlorpPublisher where: [:each | each titlesWithNumberInStock anySatisfy: [:x | x value  = 2]].
	self assert: publishers size = 1.
	self assert: publishers first id = 1."
]

{ #category : #'tests-simple reference dictionary' }
GlorpDictionaryMappingTest >> testSimpleTypeDictionaryQueryingWithAlsoFetch [
	| publishers publisherOne publisher2 q |
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.

	q := Query read: GlorpPublisher where: [:each | each id < 3].
	q orderBy: [:each | each id].
	q alsoFetch: [:each | each titlesWithNumberInStock].
	publishers := session execute: q.
	session accessor denyReads.
	
	self assert: publishers asSet size = 2.
	publisherOne := publishers detect: [:each | each id = 1].
	self assert: publisherOne titlesWithNumberInStock size = 3.
	self assert: (publisherOne titlesWithNumberInStock includesKey: 'Mastering ENVY/Developer').
	self assert: (publisherOne titlesWithNumberInStock values asArray = #(2 2 2)).

	publisher2 := publishers detect: [:each | each id = 2].
	self assert: publisher2 titlesWithNumberInStock keys asArray first = 'A book'.
	self assert: (publisher2 titlesWithNumberInStock at: 'A book') = 200.
]

{ #category : #'tests-simple reference dictionary' }
GlorpDictionaryMappingTest >> testSimpleTypeDictionaryQueryingWithFilteredReads [
	| publishers publisherOne publisher2 |
	((session system descriptorFor: GlorpPublisher) mappingForAttributeNamed: #titlesWithNumberInStock) useFilteredRead.
	"((session system descriptorFor: GlorpPublisher) mappingForAttributeNamed: #titlesWithNumberInStockLink) useFilteredRead."

	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.

	publishers := session read: GlorpPublisher where: [:each | each id < 3].
	self assert: publishers size = 2.
	publisherOne := publishers detect: [:each | each id = 1].
	self assert: publisherOne titlesWithNumberInStock size = 3.
	self assert: (publisherOne titlesWithNumberInStock includesKey: 'Mastering ENVY/Developer').
	self assert: (publisherOne titlesWithNumberInStock values asArray = #(2 2 2)).
"	self assert: publisherOne titlesWithNumberInStockLink size = 3.
	self assert: (publisherOne titlesWithNumberInStockLink includesKey: 'Mastering ENVY/Developer').
	self assert: (publisherOne titlesWithNumberInStockLink values asArray = #(2 2 2)).
"
	session accessor denyReads.
	publisher2 := publishers detect: [:each | each id = 2].
	self assert: publisher2 titlesWithNumberInStock keys asArray first = 'A book'.
"	self assert: publisher2 titlesWithNumberInStockLink keys asArray first = 'A book'."
	self assert: (publisher2 titlesWithNumberInStock at: 'A book') = 200.
"	self assert: (publisher2 titlesWithNumberInStockLink at: 'A book') = 200."
]

{ #category : #'tests-simple reference dictionary' }
GlorpDictionaryMappingTest >> testSimpleTypeDictionaryQueryingWithRetrieve [
	| publishers publisherOne publisher2 q actualPublishers |
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.

	q := Query read: GlorpPublisher where: [:each | each id < 3].
	q retrieve: [:each | each].
	q retrieve: [:each | each titlesWithNumberInStock].
	publishers := session execute: q.
	
	actualPublishers := publishers collect: [:each | each first].

	self assert: actualPublishers asSet size = 2.
	publisherOne := actualPublishers detect: [:each | each id = 1].
	self assert: publisherOne titlesWithNumberInStock size = 3.
	self assert: (publisherOne titlesWithNumberInStock includesKey: 'Mastering ENVY/Developer').
	self assert: (publisherOne titlesWithNumberInStock values asArray = #(2 2 2)).

	publisher2 := actualPublishers detect: [:each | each id = 2].
	self assert: publisher2 titlesWithNumberInStock keys asArray first = 'A book'.
	self assert: (publisher2 titlesWithNumberInStock at: 'A book') = 200.
]

{ #category : #'tests-simple reference dictionary' }
GlorpDictionaryMappingTest >> testSimpleTypeDictionaryRead [
	| publishers |
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.
	publishers := session read: GlorpPublisher where: [:each | each titlesWithNumberInStock anySatisfy: [:eachTitleAssociation |
		eachTitleAssociation value = 2]].
	self assert: publishers size = 1.
]

{ #category : #'tests-simple reference dictionary' }
GlorpDictionaryMappingTest >> testSimpleTypeDictionaryReadWithImpliedValue [
	| publishers |
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.
	publishers := session read: GlorpPublisher where: [:each | each titlesWithNumberInStock anySatisfy: [:eachTitleAssociation |
		eachTitleAssociation = 2]].
	self assert: publishers size = 1.
]

{ #category : #'tests-simple reference classes' }
GlorpDictionaryMappingTest >> testSimpleTypeOneToMany [
	| publishers |
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.
	publishers := session read: GlorpPublisher where: [:each | each id = 1].
	publishers do: [:each | 
		each titles do: [:eachTitle | self assert: eachTitle isString]].
	self assert: publishers first titles size = 3.
	self assert: publishers first titles asSortedCollection = session system examplePublisher1 titles asSortedCollection.
]

{ #category : #'tests-simple reference classes' }
GlorpDictionaryMappingTest >> testSimpleTypeOneToManyComplexQuerying [
	| publishers |
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.
	publishers := session read: GlorpPublisher where: [:each | each titles sqlCount = 3].
	self assert: publishers size = 1.
	self assert: publishers first titles size = 3.
	self assert: (publishers first titles includes: 'Mastering ENVY/Developer').
]

{ #category : #'tests-simple reference classes' }
GlorpDictionaryMappingTest >> testSimpleTypeOneToManyQuerying [
	| publishers |
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.
	publishers := session read: GlorpPublisher where: [:each | each titles anySatisfy: [:x | x like: 'Master%' ]].
	self assert: publishers size = 1.
	self assert: (publishers first titles anySatisfy: [:each | each like: 'Master%']).
]

{ #category : #'tests-simple reference classes' }
GlorpDictionaryMappingTest >> testSimpleTypeOneToManyQueryingIncludes [
	| publishers |
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.
	publishers := session read: GlorpPublisher where: [:each | each titles includes: 'Mastering ENVY/Developer' ].
	self assert: publishers size = 1.
	self assert: (publishers first titles includes: 'Mastering ENVY/Developer').
]

{ #category : #'tests-simple reference classes' }
GlorpDictionaryMappingTest >> testSimpleTypeOneToManyQueryingWithFilteredReads [
	| publishers publisherOne publisher2 |
	((session system descriptorFor: GlorpPublisher) mappingForAttributeNamed: #titles) useFilteredRead.
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.
	publishers := session read: GlorpPublisher where: [:each | each id < 3].
	self assert: publishers size = 2.
	publisherOne := publishers detect: [:each | each id = 1].
	self assert: publisherOne titles size = 3.
	self assert: (publisherOne titles includes: 'Mastering ENVY/Developer').
	session accessor denyReads.
	publisher2 := publishers detect: [:each | each id = 2].
	self assert: publisher2 titles first = 'A book'.
]

{ #category : #tests }
GlorpDictionaryMappingTest >> testUpdate [

	| encyclopedias canadian allEntryRows allLinkRows |
	encyclopedias := session system exampleEncyclopedias.
	session transact: [session register: encyclopedias].
	session reset.
	session accessor denyCommands: (Array with: DeleteCommand).
	session inUnitOfWorkDo: [
		| newEntry |
		canadian := session readOneOf: GlorpEncyclopedia where: [:each | each name like: 'The Ca%'].
		newEntry := GlorpEncyclopediaEntry new
			id: 'seven';
			title: 'The Latest Entry';
			text: 'This is all about the very newest stuff'.
		canadian entries at: 'unique' put: newEntry].
	self assert: (canadian entries at: 'abcde') id = 'two'.
	self assert: (canadian entries at: '12345') id = 'one'.
	self assert: (canadian entries at: 'unique') id = 'seven'.
	self assert: (canadian entries at: 'unique') title = 'The Latest Entry'.
	allEntryRows := session accessor executeSQLString: 'select * from ENCYC_ENTRY'.
	"We didn't actually delete the 'three' entry"
	self assert: allEntryRows size = 4.
	allLinkRows := session accessor executeSQLString: 'select * from ENCYC_ENTRY_LINK'.
	"But we should have only our 3 link table rows, plus 2 for the other encyclopedia"
	self assert: allLinkRows size = 5.
]

{ #category : #tests }
GlorpDictionaryMappingTest >> testUpdateNonLinkTable [
	"Test updating a dictionary where we don't have a link table, but the target table refers back to the containing object."
	| encyclopedias canadian bio newBio |
	encyclopedias := session system exampleEncyclopedias.
	bio := GlorpEncyclopediaBioEntry new title: 'Alan Kay'; text: 'A stub'.
	encyclopedias first biographicalEntries at: bio title put: bio.
	session transact: [session register: encyclopedias].
	session reset.
	session inUnitOfWorkDo: [
		canadian := session readOneOf: GlorpEncyclopedia where: [:each | each name like: 'The Ca%'].
		newBio := GlorpEncyclopediaBioEntry new
			title: 'Alan Kay';
			text: 'a bit more information'.
		canadian biographicalEntries at: 'Alan Kay' put: newBio].
	session reset.
	canadian := session readOneOf: GlorpEncyclopedia where: [:each | each name like: 'The Ca%'].
	self assert: canadian biographicalEntries size = 1.
	self assert: (canadian biographicalEntries at: 'Alan Kay') text = 'a bit more information'.
	self assert: (session count: GlorpEncyclopediaBioEntry) = 1.
]

{ #category : #'tests-simple reference dictionary' }
GlorpDictionaryMappingTest >> testUpdateSimpleTypeDictionaryAdding [
	| publishers publisher |
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.
	publisher := session readOneOf: GlorpPublisher where: [:each | each id = 1].
	session modify: publisher in: [
		publisher titlesWithNumberInStock at: 'New Book' put: 1].
	session reset.
	publisher := session readOneOf: GlorpPublisher where: [:each | each id = 1].
	self assert: (publisher titlesWithNumberInStock at: 'New Book') = 1.
	self assert: publisher titlesWithNumberInStock size = 4.
]

{ #category : #'tests-simple reference dictionary' }
GlorpDictionaryMappingTest >> testUpdateSimpleTypeDictionaryDeleting [
	| publishers publisher |
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.
	publisher := session readOneOf: GlorpPublisher where: [:each | each id = 1].
	session modify: publisher in: [
		publisher titlesWithNumberInStock removeKey: 'Mastering ENVY/Developer'].
	session reset.
	publisher := session readOneOf: GlorpPublisher where: [:each | each id = 1].
	self assert: (publisher titlesWithNumberInStock at: 'Mastering ENVY/Developer' ifAbsent: [999]) = 999.
	self assert: publisher titlesWithNumberInStock size = 2.
]

{ #category : #'tests-simple reference dictionary' }
GlorpDictionaryMappingTest >> testUpdateSimpleTypeDictionaryLinkModifying [
"	| publishers publisher |
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.
	publisher := session readOneOf: GlorpPublisher where: [:each | each id = 1].
	session modify: publisher in: [
		publisher titlesWithNumberInStockLink at: 'Mastering ENVY/Developer' put: 123].
	session reset.
	publisher := session readOneOf: GlorpPublisher where: [:each | each id = 1].
	self assert: (publisher titlesWithNumberInStockLink at: 'Mastering ENVY/Developer') = 123."
	"It can't find how to delete properly, because it doesn't know the primary key of the old record, and we don't have it recorded anywhere in the image"
	"self assert: (session accessor executeSQLString: 'SELECT * FROM PUBLISHER_TITLE2') size = 4.
	self assert: (session accessor executeSQLString: 'SELECT * FROM PUB_TITLE_LINK') size = 4."
]

{ #category : #'tests-simple reference dictionary' }
GlorpDictionaryMappingTest >> testUpdateSimpleTypeDictionaryLinkedAdding [
"	| publishers publisher |
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.
	publisher := session readOneOf: GlorpPublisher where: [:each | each id = 1].
	session modify: publisher in: [
		publisher titlesWithNumberInStockLink at: 'New Book' put: 1].
	session reset.
	publisher := session readOneOf: GlorpPublisher where: [:each | each id = 1].
	self assert: (publisher titlesWithNumberInStockLink at: 'New Book') = 1.
	self assert: publisher titlesWithNumberInStockLink size = 4."
]

{ #category : #'tests-simple reference dictionary' }
GlorpDictionaryMappingTest >> testUpdateSimpleTypeDictionaryLinkedDeleting [
"	| publishers publisher |
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.
	publisher := session readOneOf: GlorpPublisher where: [:each | each id = 1].
	session modify: publisher in: [
		publisher titlesWithNumberInStockLink removeKey: 'Mastering ENVY/Developer'].
	session reset.
	publisher := session readOneOf: GlorpPublisher where: [:each | each id = 1].
	self assert: (publisher titlesWithNumberInStockLink at: 'Mastering ENVY/Developer' ifAbsent: [999]) = 999.
	self assert: publisher titlesWithNumberInStockLink size = 2."
]

{ #category : #'tests-simple reference dictionary' }
GlorpDictionaryMappingTest >> testUpdateSimpleTypeDictionaryModifying [
	| publishers publisher |
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.
	publisher := session readOneOf: GlorpPublisher where: [:each | each id = 1].
	session modify: publisher in: [
		publisher titlesWithNumberInStock at: 'Mastering ENVY/Developer' put: 123].
	session reset.
	publisher := session readOneOf: GlorpPublisher where: [:each | each id = 1].
	self assert: (publisher titlesWithNumberInStock at: 'Mastering ENVY/Developer') = 123.
]

{ #category : #'tests-simple reference classes' }
GlorpDictionaryMappingTest >> testUpdateSimpleTypeOneToMany [
	| publishers publisher |
	self assert: (session read: GlorpPublisher) isEmpty.
	publishers := session system examplePublishers.
	session modify: publishers in: [].
	session reset.
	publisher := session readOneOf: GlorpPublisher where: [:each | each id = 1].
	session modify: publisher in: [
		publisher titles: (Array with: 'New Improved Book'), publisher titles].
	session reset.
	publisher := session readOneOf: GlorpPublisher where: [:each | each id = 1].
	self assert: publisher titles size = 4.
	self assert: publisher titles asSortedCollection = (session system examplePublisher1 titles , (Array with: 'New Improved Book')) asSortedCollection.
]

{ #category : #tests }
GlorpDictionaryMappingTest >> testWriteAndReadBack [
	| encyclopedias query readBackEncyclopedias |
	encyclopedias := session system exampleEncyclopedias.
	session transact: [session register: encyclopedias].
	session reset.
	query := Query read: GlorpEncyclopedia.
	query orderBy: [:each | each name].
	readBackEncyclopedias := session execute: query.
	self verifyEncyclopedias: readBackEncyclopedias.
]

{ #category : #'tests-key in different tables' }
GlorpDictionaryMappingTest >> testWriteAndReadBackKeyInLinkTable [

	| query readBackPublishers publishers withEmps |
	publishers := session system examplePublishers.
	session transact: [session register: publishers].
	session reset.
	query := Query read: GlorpPublisher.
	query orderBy: [:each | each name].
	readBackPublishers := session execute: query.
	self assert: readBackPublishers size = 3.
	withEmps := readBackPublishers at: 2.
	self assert: withEmps name = 'Cambridge'.
	self assert: withEmps differentBunchOfEmployeesById size = 2.
	self assert: withEmps differentBunchOfEmployeesById keys asSortedCollection asArray = #(3 4).
	self assert: (withEmps differentBunchOfEmployeesById at: 3) name = 'Contractor 1'.
	self assert: (withEmps differentBunchOfEmployeesById at: 4) name = 'Contractor 2'.
]

{ #category : #'tests-key in different tables' }
GlorpDictionaryMappingTest >> testWriteAndReadBackKeyInTargetTable [

	| query readBackPublishers publishers withEmps |
	publishers := session system examplePublishers.
	session transact: [session register: publishers].
	session reset.
	query := Query read: GlorpPublisher.
	query orderBy: [:each | each name].
	readBackPublishers := session execute: query.
	self assert: readBackPublishers size = 3.
	withEmps := readBackPublishers at: 2.
	self assert: withEmps name = 'Cambridge'.
	self assert: withEmps employees size = 2.
	self assert: withEmps employees keys asSortedCollection asArray = #('CEO' 'Editor').
	self assert: (withEmps employees at: 'CEO') name = 'The Boss'.
	self assert: (withEmps employees at: 'Editor') name = 'Somebody'.
]

{ #category : #tests }
GlorpDictionaryMappingTest >> verifyEncyclopedias: readBackEncyclopedias [
	| plagiarists canadian |
	self assert: readBackEncyclopedias size = 3.
	canadian := readBackEncyclopedias first.
	self assert: canadian name = 'The Canadian Encyclopedia'.
	self assert: canadian entries size = 3.
	self assert: (canadian entries at: 'abcde') id = 'two'.
	self assert: (canadian entries at: '12345') id = 'one'.
	self assert: (canadian entries at: 'unique') id = 'three'.
	plagiarists := readBackEncyclopedias at: 2.
	self assert: plagiarists entries size = 2.
	self
		assert:
			(plagiarists entries at: '54321') = (canadian entries at: '12345').
	self
		assert:
			(plagiarists entries at: 'edcba') = (canadian entries at: 'abcde').
	self assert: readBackEncyclopedias last entries isEmpty.
]
