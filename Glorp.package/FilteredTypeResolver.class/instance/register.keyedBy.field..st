registering
register: aDescriptor keyedBy: aKey field: aField
	self register: aDescriptor abstract: false.
	aDescriptor typeMapping: (FilteredTypeMapping to: aField keyedBy: aKey)