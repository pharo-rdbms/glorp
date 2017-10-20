mapping
createRowsFor: anObject in: aRowMap
	| row |
	anObject class == self describedClass
		ifFalse: [self error: 'wrong descriptor for this object'].
	mappings do: [:each | 
			each stopIfDebuggingWrite.
			each mapFromObject: anObject intoRowsIn: aRowMap].

	"If we haven't written out our primary keys, then make sure we do so, but if absolutely none of our mappings have written anything, then just ignore it."
	row := aRowMap rowForTable: self primaryTable withKey: anObject ifAbsent: [^self].
	self primaryTable primaryKeyFields do: [:each | 
		self setFieldValue: each 	in: row from: anObject].

	"This is a bit of a hack/heuristic. If the multiple table join is an outer join, and the row doesn't exist yet, then assume we won't need it and don't do the join. It means none of our mappings wrote to it. Hope that in that case no one else's will. It seems reasonable that we wouldn't map an object to multiple tables unless we planned to map some field within it, but it's still a bit of a risk."
	self multipleTableJoin do: [:each | 
		(each isOuterJoin not or: [each allTables anySatisfy: [:eachTable | 
			aRowMap includesRowForTable: eachTable withKey: anObject]]) 
				ifTrue: [
					each
						mapFromSource: anObject
						andTarget: anObject
						intoRowsIn: aRowMap]]