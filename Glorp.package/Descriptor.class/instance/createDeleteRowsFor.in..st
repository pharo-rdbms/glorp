deleting
createDeleteRowsFor: anObject in: aRowMap
	"Create records for rows that require deletion"

	|  |
	anObject class == self describedClass ifFalse: [self error: 'wrong descriptor for this object'].
	"If we don't map primary keys, then we're something that gets embedded, and a delete isn't necessary"
	self mapsPrimaryKeys ifFalse: [^self]. 

	self tables do: [:eachTable |
		self createDeleteRowFor: anObject table: eachTable in: aRowMap.
		aRowMap rowForTable: eachTable withKey: anObject ifPresent: [:eachRow | eachRow forDeletion: true]].
	"It's possible that we might not have any direct mapping for a secondary table's primary keys, so 
allow the multiple table criteria to specify them if that's the only one. If they're not, then they don't do any harm"
	self multipleTableJoin do: [:each |
		each mapFromSource: anObject andTarget: anObject intoRowsIn: aRowMap.
		each allTables do: [:eachTable |
			aRowMap rowForTable: eachTable withKey: anObject ifPresent: [:eachRow | eachRow forDeletion: true]]].

	self mappings do: [:each | each  createDeleteRowFor: anObject in: aRowMap]