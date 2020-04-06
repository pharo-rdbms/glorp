Class {
	#name : #GlorpAttributeModelTest,
	#superclass : #GlorpTestCase,
	#category : 'Glorp-Tests-Tests'
}

{ #category : #tests }
GlorpAttributeModelTest >> testDictionaryTypes [
	| attributeModel obj classModel dict model |
	dict := Dictionary new at: #one put: 'two'; yourself.
	obj := 1@dict.

	classModel := GlorpClassModel for: Point.
	attributeModel := classModel newAttributeNamed: #y dictionaryFrom: Symbol to: String.
	model := classModel attributeNamed: #y.
	self assert: model == attributeModel.
	self assert: model keyType == Symbol.
	self assert: model type == String.

	self assert: dict == (attributeModel getValueFrom: obj).
	attributeModel setValueIn: obj to: nil.
	self assert: nil == (attributeModel getValueFrom: obj).
]

{ #category : #tests }
GlorpAttributeModelTest >> testGetSetAssociation [
	| attributeModel obj classModel |
	obj := nil->2.

	classModel := GlorpClassModel for: Association.
	attributeModel := classModel newAttributeNamed: #value.

	attributeModel useDirectAccess: true.
	self assert: 2 == (attributeModel getValueFrom: obj).
	attributeModel setValueIn: obj to: 3.
	self assert: 3 == (attributeModel getValueFrom: obj).

	attributeModel useDirectAccess: false.
	self assert: 3 == (attributeModel getValueFrom: obj).
	attributeModel setValueIn: obj to: 2.
	self assert: 2 == (attributeModel getValueFrom: obj).
]

{ #category : #tests }
GlorpAttributeModelTest >> testGetSetObject [
	| attributeModel obj classModel |
	obj := (GlorpObjectWithNoAccessors new)
								extremelyPrivateValue: 'Glorp';
								yourself.

	classModel := GlorpClassModel for: GlorpObjectWithNoAccessors.
	attributeModel := classModel newAttributeNamed: #alue.

	attributeModel useDirectAccess: true.
	self assert: 'Glorp' = (attributeModel getValueFrom: obj).
	attributeModel setValueIn: obj to: 'GLORP'.
	self assert: 'GLORP' = (attributeModel getValueFrom: obj).

	attributeModel useDirectAccess: false.
	self should: [attributeModel getValueFrom: obj] raise: Dialect error.
	self should: [attributeModel setValueIn: obj to: 'Glorp'] raise: Dialect error.
]

{ #category : #tests }
GlorpAttributeModelTest >> testPreserveAttributes [
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
]
