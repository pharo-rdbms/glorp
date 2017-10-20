containing
isNowContainedBy: aRow and: aField
	"Optimize this for memory consumption with the common case of one container. If we're contained by nothing, make it a single association. Otherwise, use a dictionary"
	| shortCircuit thisFieldsEntries |
	shortCircuit := false.
	containedBy == nil ifTrue: [containedBy := aField -> ((IdentitySet new: 2) add: aRow; yourself). ^self].
	containedBy class == Association 
		ifTrue: [
		containedBy key == aField
			ifTrue: [thisFieldsEntries := containedBy value]
			ifFalse: [ | newContainedBy |
				newContainedBy := IdentityDictionary new. 
				newContainedBy at: containedBy key put: containedBy value.
				containedBy := newContainedBy]].
	thisFieldsEntries isNil ifTrue: [
		thisFieldsEntries := containedBy at: aField ifAbsentPut: [shortCircuit := true. (IdentitySet new: 2) add: aRow; yourself]].
	shortCircuit ifTrue: [^self].
	(thisFieldsEntries includes: aRow) ifFalse: [thisFieldsEntries add: aRow]