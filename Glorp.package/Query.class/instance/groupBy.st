ordering
groupBy
	"Preserve prior behaviour:  return nil or the first groupBy, which previously was the only groupBy and will likely be the only groupBy in all cases where calling this makes sense.  The sole known appropriate use for this method is to allow a prior version of Glorp to be loaded from Store.  However it can be used as a shortcut when it is known that grouping only has one item (or the first is intentionally sought).  As with #setOrdering:, we make the assumption that noone will ever #setGrouping: to an empty collection or a collection that is later emptied (all checks of ordering assume nil is the only empty condition that need be considered)."

	^grouping isNil ifFalse: [grouping first]