building objects
buildersThatReturnResults
	buildersThatReturnResults isNil ifTrue: [
		buildersThatReturnResults := OrderedCollection new.
		builders
			do: [:each | 	
				| expression shouldBeRetrieved |
				"For some bizarre reason, includes: fails on ObjectStudio for this"
				expression := each expression.
				shouldBeRetrieved := (self query tracing retrievalExpressions detect: [:foo |
					foo == expression] ifNone: [nil]) notNil.
				(shouldBeRetrieved and: [
					(buildersThatReturnResults anySatisfy: [:eachBuilder | eachBuilder expression == expression]) not])
						ifTrue: [buildersThatReturnResults add: each]].
		buildersThatReturnResults := buildersThatReturnResults asArray].
	^buildersThatReturnResults.