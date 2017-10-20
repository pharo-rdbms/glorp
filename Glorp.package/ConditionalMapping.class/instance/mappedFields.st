accessing
mappedFields

	| all |
	all := Set new.
	conditionalFieldMapping isNil 
		ifTrue: [conditionalField ifNotNil: [all add: conditionalField]]
		ifFalse: [all addAll: conditionalFieldMapping mappedFields].
	cases do: [:each |
		all addAll: each value mappedFields].
	^all