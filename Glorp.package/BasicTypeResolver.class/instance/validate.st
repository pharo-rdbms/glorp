validation
validate
	| tables sequences |
	super validate.
	tables := self concreteMembers collect: [:each | each primaryTable].
	sequences := tables inject: #() into: [:sum :each | sum, ((each primaryKeyFields) collect: [:eachField | eachField type sequence])].
	sequences := sequences reject: #isNil.
	sequences asSet size > 1 ifTrue: [self error: 'When using inheritance, all tables must use the same sequence. Otherwise, the primary key references will be ambiguous.']