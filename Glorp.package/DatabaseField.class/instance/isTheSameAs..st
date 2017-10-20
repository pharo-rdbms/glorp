comparing
isTheSameAs: aDatabaseField
	"Validate that two fields are exactly the same. Most useful for testing purposes, rather than normal usage, which is why we don't just use the #= method."
	self name asUppercase = aDatabaseField name asUppercase ifFalse: [^false].
	self isPrimaryKey = aDatabaseField isPrimaryKey ifFalse: [^false].
	(self isTheSameTypeAs: aDatabaseField) ifFalse: [^false].
	self isNullable = aDatabaseField isNullable ifFalse: [^false].
	self isUnique = aDatabaseField isUnique ifFalse: [^false].
	self isLockKey = aDatabaseField isLockKey ifFalse: [^false].
	self defaultValue = aDatabaseField defaultValue ifFalse: [^false].
	^true.