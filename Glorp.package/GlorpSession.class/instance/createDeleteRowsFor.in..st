internal/writing
createDeleteRowsFor: anObject in: rowMap
	"Create records for rows that require deletion"

	(self descriptorFor: anObject) createDeleteRowsFor: anObject in: rowMap