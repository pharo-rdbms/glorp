Tests
someCode
	| model descriptor mapping table |
	table := DatabaseTable named: 'TYPETESTS'.
	table createFieldNamed: 'test' type: system platform boolean.
	model := system addClassModelFor: GlorpTypeTestsModelClass.
	model newAttributeNamed: #test type: Boolean.
	system privateTableAt: table name put: table.
	descriptor := Descriptor new.
	descriptor system: system.
	descriptor classModel: model.
	descriptor table: table.
	descriptor 
		addMapping: (DirectMapping from: #id to: (table fieldNamed: 'id')).
	Boolean isNil 
		ifTrue: [mapping := DirectMapping from: #test to: (table fieldNamed: 'test')]
		ifFalse: 
			[mapping := DirectMapping 
						from: #test
						type: Boolean
						to: (table fieldNamed: 'test')].
	descriptor addMapping: mapping.
	system privateDescriptorAt: GlorpTypeTestsModelClass put: descriptor.
	^system