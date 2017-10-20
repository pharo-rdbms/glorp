mapping
buildRowMapKeyForSource: source target: target index: index
	"What should this do??? We want to distinguish the entries in e.g. # (1 2 3 3 4 3 5). Or do we? They aren't distinguishable in the DB. Does that mean we always want to write the order field? Or what? What if this is a set in memory. Then we really can't have two entries"
	^MultipleRowMapKey
		with: target yourSelf
		with: source yourSelf
		with: index