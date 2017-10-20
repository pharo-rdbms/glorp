tests-simple reference dictionary
testSimpleTypeDictionaryQueryingWithRetrieve
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