api
unifyField: eachSourceField withField: eachTargetField inRow: targetRow
	| sourceWrapper targetWrapper |
	sourceWrapper := self wrapperAt: eachSourceField ifAbsent: [nil].
	targetWrapper := targetRow wrapperAt: eachTargetField ifAbsent: [nil].
	sourceWrapper isNil
		ifTrue:
			[targetWrapper isNil
				ifTrue:
					[targetWrapper := FieldValueWrapper new.
					targetRow wrapperAt: eachTargetField put: targetWrapper].
			^self wrapperAt: eachSourceField put: targetWrapper].
	targetWrapper isNil ifTrue: [^targetRow wrapperAt: eachTargetField put: sourceWrapper].
	sourceWrapper unifyWith: targetWrapper.