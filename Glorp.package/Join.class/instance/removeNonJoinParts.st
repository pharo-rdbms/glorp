preparing
removeNonJoinParts
	"Remove anything that's not an actual join. Only useful if we have something that has mixed joins and general expressions, where we assume we don't want to use the general ones, because they're not field level."
	^self.