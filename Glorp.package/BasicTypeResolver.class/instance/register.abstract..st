registering
register: aDescriptor abstract: abstract

	super register: aDescriptor abstract: abstract.
	abstract ifFalse: [ self concreteMembers add: aDescriptor ]