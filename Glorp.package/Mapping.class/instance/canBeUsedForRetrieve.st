testing
canBeUsedForRetrieve
	"Return true if this is a valid argument for a retrieve: clause"
	self isRelationship ifFalse: [^true].
	^self isToManyRelationship not.