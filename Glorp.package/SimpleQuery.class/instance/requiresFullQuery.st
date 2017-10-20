testing
requiresFullQuery
	| descriptor independent |
	descriptor := self descriptor.
	"This isn't even a valid query."
	descriptor isNil ifTrue: [^false].
	independent := descriptor classesRequiringIndependentQueries.
	^(independent size ~= 1) or: [(independent at: 1) ~= descriptor describedClass]