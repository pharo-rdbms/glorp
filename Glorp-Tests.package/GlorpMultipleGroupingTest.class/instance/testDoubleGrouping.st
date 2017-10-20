tests
testDoubleGrouping
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