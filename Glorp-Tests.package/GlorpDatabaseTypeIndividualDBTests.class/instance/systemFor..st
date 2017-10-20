setUp
systemFor: aTable
	| system descriptor mapping model |
	system := DynamicDescriptorSystem new.
	model := system addClassModelFor: GlorpTypeTestsModelClass.
	model newAttributeNamed: #id.
	model newAttributeNamed: #test type: stType.
	system privateTableAt: aTable name put: aTable.
	descriptor := Descriptor new.
	descriptor system: system.
	descriptor classModel: model.
	descriptor table: aTable.
	descriptor
		addMapping: (DirectMapping from: #id to: (aTable fieldNamed: 'id')).
	stType isNil
		ifTrue:
			[mapping := DirectMapping from: #test to: (aTable fieldNamed: 'test')]
		ifFalse:
			[mapping := DirectMapping
				from: #test
				type: stType
				to: (aTable fieldNamed: 'test')].
	descriptor addMapping: mapping.
	system privateDescriptorAt: GlorpTypeTestsModelClass put: descriptor.
	^system.