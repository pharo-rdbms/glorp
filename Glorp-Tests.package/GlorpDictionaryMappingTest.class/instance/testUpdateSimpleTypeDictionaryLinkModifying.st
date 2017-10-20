tests-simple reference dictionary
testUpdateSimpleTypeDictionaryLinkModifying
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