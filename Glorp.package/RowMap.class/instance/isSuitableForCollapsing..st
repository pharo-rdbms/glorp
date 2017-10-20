private/deletion
isSuitableForCollapsing: eachTablesRows
	"Return true if this set of rows are suitable for collapsing the inserts and deletes together. It's suitable if this is a link table, and if there is a primary key defined which we can use to decide if the rows match or not"
	eachTablesRows isEmpty ifTrue: [^false].
	eachTablesRows
		keysAndValuesDo:
			[:eachKey :eachRow | 
				"(self isRowMapKey: eachKey) ifFalse: [^false]."
				eachRow table primaryKeyFields isEmpty ifTrue: [^false].
				^true ]