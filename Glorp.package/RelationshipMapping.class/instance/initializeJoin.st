initializing
initializeJoin
	"We haven't been given a join. There might be a compound one, or else see if we can make an educated guess at one"
	linkTableJoin notNil ifTrue: [join := linkTableJoin, targetTableJoin. ^self].
	self initializeJoinTo: self relatedTables.