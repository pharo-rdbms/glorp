registering
register: aDescriptor abstract: aBoolean
	super register: aDescriptor abstract: aBoolean.
	aBoolean
		ifTrue:
			[| fakeTypeMapping |
			fakeTypeMapping := FilteredTypeMapping to: nil keyedBy: nil.
			fakeTypeMapping attribute name: #filteredTypeResolverFilterMapping.
			fakeTypeMapping readOnly: true.
			aDescriptor typeMapping: fakeTypeMapping]