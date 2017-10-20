accessing
qualifiedName

	^(schema isNil or: [schema isEmpty]) ifTrue: [name] ifFalse: [schema, '.', name].