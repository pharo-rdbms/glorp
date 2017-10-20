accessing
descriptor: aDescriptor

	super descriptor: aDescriptor.
	cases do: [:each | each value descriptor: aDescriptor].
	otherwiseCase isNil ifFalse: [otherwiseCase descriptor: aDescriptor].
	conditionalFieldMapping isNil ifFalse: [conditionalFieldMapping descriptor: aDescriptor]