support
realObjectsFrom: aVirtualCollection
	"Get the real objects from a virtual collection without resorting to any of its mechanisms except do:, so we can validate against more complex things."
	| all |
	all := OrderedCollection new.
	aVirtualCollection do: [:each | all add: each].
	^all.