services tables
ddlTableNameFor: aTableOrString
	"
	Either a databaseTable or a string can be passed in the argument.
	"

	^ aTableOrString isString
		ifTrue: [ self capitalWritingOfTableName 
			ifTrue: [ aTableOrString asUppercase ] 
			ifFalse:[ aTableOrString ] ]
		ifFalse: [ self ddlTableNameFor: aTableOrString qualifiedName ]