mapping
parametersIn: anElementBuilder
	| parameters |
	parameters := IdentityDictionary new.
	descriptor primaryTable primaryKeyFields do: [:each | parameters at: each put: (anElementBuilder valueOfField: each)].
	^parameters