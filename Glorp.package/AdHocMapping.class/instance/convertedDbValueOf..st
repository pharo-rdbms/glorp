printing SQL
convertedDbValueOf: anObject
	| tables rows |
	tables := self mappedTables.
	rows := Dictionary new.
	tables do: [:each | rows at: each put: (DatabaseRow newForTable: each)].
	toDbMappingBlock value: rows value: anObject.
	rows keysAndValuesDo: [:eachTable :eachRow |
		^eachRow at: mappedFields first].