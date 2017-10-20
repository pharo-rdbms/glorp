tests
testPreserveAttributes
	| attributeModel classModel descriptor mapping table field system |
	system := DynamicDescriptorSystem new.
	classModel := system addClassModelFor: Association.
	attributeModel := classModel newAttributeNamed: #key.
	descriptor := Descriptor new.
	descriptor classModel: classModel.
	table := DatabaseTable named: 'FRED'.
	field := table createFieldNamed: 'BARNEY' type: OraclePlatform new int4.
	mapping := DirectMapping from: #key type: Object to: field.
	self assert: mapping attributeAccessor useDirectAccess.
	self assert: attributeModel useDirectAccess.

	mapping attributeAccessor useDirectAccess: false.
	self assert: mapping attribute type == Object.
	descriptor addMapping: mapping.
	self assert: mapping attribute == attributeModel.
	self assert: mapping attribute == mapping attributeAccessor.
	self assert: attributeModel type == Object.
	self deny: attributeModel useDirectAccess.