private/mapping
rowsForKey: aKey
	"Return a collection of all rows for any table which are keyed by aKey"

	| rowsForKey |
	rowsForKey := OrderedCollection new: 5.
	rowDictionary
		do:
			[:each | 
			| row |
			row := each at: aKey ifAbsent: [nil].
			(row notNil and: [(self isDeleted: row) not]) ifTrue: [rowsForKey add: row]].
	^rowsForKey