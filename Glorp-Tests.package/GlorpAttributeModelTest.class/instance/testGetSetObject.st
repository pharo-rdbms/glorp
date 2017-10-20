tests
testGetSetObject
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