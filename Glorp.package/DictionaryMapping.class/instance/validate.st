validation
validate
	self initializeValueMapping.
	super validate.
	self attribute isDictionaryAttribute
		ifFalse: [self error: 'Dictionary Mapping that does not have a dictionary type in the attribute'].

	"The reason you can't do this, is that we end up throwing away the primary key of the target table when we read in the objects, and we have no way to properly do deletes/updates without that information"
	(self usesLinkTable and: [self mapsSimpleObject]) ifTrue: [self error: 'Dictionary mappings to simple objects cannot use a link table'].