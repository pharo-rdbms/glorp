accessing
addMember: aDescriptor
	members isNil ifTrue: [members := OrderedCollection new].
	(members includes: aDescriptor)
		ifFalse: [members add: aDescriptor]
		ifTrue: [Transcript cr; show: ('Your system does a duplicate registration of ', aDescriptor printString, ' in ', self printString)]