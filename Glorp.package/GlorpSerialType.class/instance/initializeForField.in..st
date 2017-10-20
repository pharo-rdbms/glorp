initialize
initializeForField: aDatabaseField in: aDescriptorSystem
	sequence isNil
		ifFalse: [ ^ self ].
	aDatabaseField table name = 'PARENT' ifTrue: [ Halt now ].
	sequence := aDescriptorSystem
		databaseSequenceNamed: (aDescriptorSystem sequenceNameForField: aDatabaseField).
	aDatabaseField platform supportsSettingSequenceIncrement
		ifTrue: [ increment := aDatabaseField type increment isNil
				ifFalse: [ sequence sequenceIncrement: increment ] ].
	sequence schema: aDatabaseField table schema