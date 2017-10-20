helpers
helpTestValueWithUnitOfWorkWrite: anObject compareModelWith: aBlock
	| typeTestModel system model |
	system := self systemFor: table.
	session system: system.
	self inTransactionDo: [
	session beginUnitOfWork.
	model := GlorpTypeTestsModelClass new test: anObject.
	session register: model.
	session commitUnitOfWork.
	session reset.
	(session platform canUseInWhereClause: anObject type: type) ifTrue: [
		typeTestModel := self readBackModelWithValue: anObject.
		self assert: (aBlock value: typeTestModel value: anObject)]].