validation
unmappedInstanceVariables
	"Return a list, for all of our classes, of instance variables with no mappings. This can be used by inspection to see if we're missing mappings we think we ought to have."
	"self unmappedInstanceVariables"

	| unmapped |
	unmapped := Dictionary new.
	self allClasses do: [:eachClass |
		eachClass allInstVarNames do: [:eachInstVarName |
			((self descriptorFor: eachClass) mappingForAttributeNamed: eachInstVarName asSymbol)
				isNil ifTrue: [
					(unmapped at: eachClass ifAbsentPut: [OrderedCollection new])
						add: eachInstVarName]]].
	^unmapped