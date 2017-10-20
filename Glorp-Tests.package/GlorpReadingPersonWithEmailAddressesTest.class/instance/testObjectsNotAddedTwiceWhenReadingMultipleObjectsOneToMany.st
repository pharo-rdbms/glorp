tests
testObjectsNotAddedTwiceWhenReadingMultipleObjectsOneToMany
	"Read in the objects first, so they're in cache. Make sure they don't get the collection built up twice."
	| people |

	people := session read: GlorpPerson.
	self testReadMultipleObjectsOneToMany.
	^people.