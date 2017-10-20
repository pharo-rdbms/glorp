testing
supportsOrderingFor: aDescriptor
	concreteMembers detect: [:each | each == aDescriptor] ifNone: [^false].
	^true