mapping
createDeleteRowForLinkFrom: anObject toTarget: target in: aRowMap
	| linkTable |
	self usesLinkTable ifFalse: [^false].
	linkTable := self linkTableJoin allTables asArray first.
	self attribute
		loopOver: target
		doing:
			[:index :eachTarget | 
			| intermediate |
			intermediate := self
				rowMapKeyForSource: anObject
				target: eachTarget
				index: index.
			aRowMap
				rowForTable: linkTable
				withKey: intermediate
				ifPresent:
					[:linkRow | linkRow isEmpty ifFalse: [linkRow forDeletion: true]]].