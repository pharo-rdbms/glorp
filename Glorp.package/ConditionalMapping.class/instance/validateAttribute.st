validation
validateAttribute
	cases do: [:each | each value validateAttribute].
	otherwiseCase validateAttribute.
	conditionalFieldMapping isNil ifFalse: [conditionalFieldMapping validateAttribute].