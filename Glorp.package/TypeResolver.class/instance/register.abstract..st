registering
register: aDescriptor abstract: abstract

	self system: aDescriptor system.
	self addMember: aDescriptor.
	aDescriptor typeResolver: self