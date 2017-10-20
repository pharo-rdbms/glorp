sequences
sequenceNameForField: aDatabaseField
	"Return the name of the sequence we will use for a field. Subclasses can override to use different naming conventions."
	^(aDatabaseField table sqlString), '_', (aDatabaseField name), '_seq'