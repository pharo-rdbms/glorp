printing
printJoinsOn: aCommand
	"This is pretty hideous. Figure out an order in which to print these stupid joins. As a bonus, they may be circular, so we may have to collapse joins together. And if we collapse, we can't print as we go because we don't know how many parentheses to add, so store them up and print them all at the end"
	| allJoins |
	joinsToProcess := query joins copy.
	availableTables := Set with: self rootTable.
	allJoins := OrderedCollection new.
	[joinsToProcess isEmpty] whileFalse: [
		| next nextTable allRelatedJoins fullJoin|
		next := self nextJoin.
		joinsToProcess remove: next.
		nextTable := next tableToJoinFrom: availableTables.
		allRelatedJoins := joinsToProcess select: [:each | (each tableToJoinFrom: availableTables) = nextTable].
		fullJoin := allRelatedJoins inject: next into: [:sum :each | sum AND: each].
		joinsToProcess removeAll: allRelatedJoins.
		allJoins add: (fullJoin->nextTable).
		availableTables addAll: (next tablesForANSIJoin)].
	allJoins size timesRepeat: [aCommand platform parenthesizeCommandsInCompoundQuery ifTrue: [aCommand nextPut: $(]].
	aCommand nextPutAll: self rootTable sqlTableName.
	allJoins do: [:each | 
		each key printForANSIJoinTo: each value on: aCommand.
		aCommand platform parenthesizeCommandsInCompoundQuery ifTrue: [aCommand nextPut: $)]].
	self printLeftoverTablesOn: aCommand