deleting
createDeleteRowFor: anObject table: aTable in: aRowMap
	"Create records for rows that require deletion"

	(self primaryKeyMappingsFor: aTable)
		do: [:each | 
			each first mapFromObject: anObject intoRowsIn: aRowMap]