copying
isSameAliasedFieldAs: aField
	"Return true if we are the same as another aliased field. For non-aliased fields, identity is assured, so this is redundant. Note that we == the string. This will work because we know these must both be shallow copies of the same thing"
	self class == aField class ifFalse: [^false].
	^self table == aField table and: [self name == aField name].