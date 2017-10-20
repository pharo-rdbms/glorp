api
mapFromSource: sourceObject andTarget: targetObject intoRowsIn: aRowMap
	(sourceObject isNil or: [targetObject isNil]) ifTrue: [^self].
	1
		to: sources size
		do:
			[:i | 
			| eachSourceField eachTargetField |
			eachSourceField := sources at: i.
			eachTargetField := targets at: i.
			(self isConstant: eachSourceField)
				ifTrue: [aRowMap at: eachTargetField key: targetObject put: eachSourceField value]
				ifFalse:
					[aRowMap
						unifyField: eachSourceField
						key: sourceObject
						withField: eachTargetField
						key: targetObject]].