tests
testDictionaryTypes
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