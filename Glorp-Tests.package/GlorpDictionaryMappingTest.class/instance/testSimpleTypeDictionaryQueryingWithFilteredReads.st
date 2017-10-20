tests-simple reference dictionary
testSimpleTypeDictionaryQueryingWithFilteredReads
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