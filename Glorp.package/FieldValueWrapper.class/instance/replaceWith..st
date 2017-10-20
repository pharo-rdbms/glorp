unifying
replaceWith: aFieldValueWrapper
	containedBy isNil ifTrue: [^nil].
	containedBy
		keysAndValuesDo:
			[:eachField :eachListOfRows | eachListOfRows do: [:eachRow | eachRow wrapperAt: eachField put: aFieldValueWrapper]]