table creation
updateTableFrom: aTable to: newTable
	"Update the given table based on the metadata."
	
	| newFields deletedFields modifiedFields newFKConstraints deletedFKConstraints newUniqueConstraints deletedUniqueConstraints |
	newFKConstraints := newTable foreignKeyConstraints reject: 
		[:each | aTable hasForeignKeyConstraintMatching: each].
	deletedFKConstraints := aTable foreignKeyConstraints reject: 
		[:each | newTable hasForeignKeyConstraintMatching: each].
	newUniqueConstraints := newTable uniqueConstraints reject: 
		[:each | aTable hasUniqueConstraintMatching: each].
	deletedUniqueConstraints := aTable uniqueConstraints reject: 
		[:each | newTable hasUniqueConstraintMatching: each].
	"So far, we just handle adding and deleting fields, not changing them."
	newFields := newTable fields reject: 
		[:each | aTable hasFieldNamed: each name].
	deletedFields := aTable fields reject: 
		[:each | newTable hasFieldNamed: each name].
	modifiedFields := newTable fields reject: 
		[:each | newFields includes: each].
	modifiedFields := modifiedFields reject: 
		[:each | (aTable fieldNamed: each name) isTheSameAs: each].	
	"Cheap version, for modified fields, drop and re-add them."
	newFields addAll: modifiedFields.
	deletedFields addAll: modifiedFields.
	deletedFKConstraints do: [:each | accessor dropConstraint: each].
	deletedUniqueConstraints do: [:each | accessor dropConstraint: each].
	accessor dropFields: deletedFields.
	accessor addFields: newFields.
	newFKConstraints do: [:each | accessor addConstraint: each].
	newUniqueConstraints do: [:each | accessor addConstraint: each]