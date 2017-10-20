preparing
condensePrimaryKeyComparison
	"Relies on this having been called after the children are condensed. If the child has had its reference to our base condensed away, then we aren't necessary, the comparison is at the same level and no longer needs a subselect"
	^leftChild queryLevelBaseExpression == rightChild queryLevelBaseExpression ifTrue: [rightChild] ifFalse: [self].