type mapping
registerTypeResolver: aResolver abstract: shouldBeAbstract
	shouldBeAbstract ifFalse: [ self beAbstract ].
	aResolver register: self