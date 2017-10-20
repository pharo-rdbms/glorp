tests
testGetSetAssociation
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