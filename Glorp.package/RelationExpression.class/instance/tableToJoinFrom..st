As yet unclassified
tableToJoinFrom: aTableCollection
	"Return a table we could legitimately use at this point to write as an ANSI join - meaning that all but one must be  already used and thus available, and one that isn't. aTableCollection lists the used ones"
	| possibleTables |
	possibleTables := self tablesForANSIJoin asArray
		select: [:each | (aTableCollection includes: each) not].
	^possibleTables size = 1 ifTrue: [possibleTables first] ifFalse: [nil].