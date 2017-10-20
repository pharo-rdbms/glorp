initialize
initializeForField: aDatabaseField in: aDescriptorSystem

	sequence isNil ifFalse: [^self].
	sequence := aDescriptorSystem
				databaseIdentitySequenceNamed: (aDescriptorSystem sequenceNameForField: aDatabaseField).
	sequence schema: aDatabaseField table schema