testing
matchesField: aField
	table name = aField table name ifFalse: [^false].
	name = aField name ifFalse: [^false].
	isNullable = aField isNullable ifFalse: [^false].
	isPrimaryKey = aField isPrimaryKey ifFalse: [^false].
	isUnique = aField isUnique ifFalse: [^false].
	^true