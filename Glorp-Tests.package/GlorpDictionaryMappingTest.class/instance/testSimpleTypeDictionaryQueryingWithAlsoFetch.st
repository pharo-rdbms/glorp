tests-simple reference dictionary
testSimpleTypeDictionaryQueryingWithAlsoFetch
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