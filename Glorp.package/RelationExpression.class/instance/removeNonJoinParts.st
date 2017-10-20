preparing
removeNonJoinParts
	"Remove anything that's not an actual join. Only useful if we have something that has mixed joins and general expressions, where we assume we don't want to use the general ones, because they're not field level. Also only meaningful to remove this for ANDs and ORs, not sub-components."
	(relation = #AND or: [relation = #OR]) ifFalse: [^self].
	leftChild := leftChild isJoin ifTrue: [leftChild] ifFalse: [true asGlorpExpression].
	rightChild := rightChild isJoin ifTrue: [rightChild] ifFalse: [true asGlorpExpression].