relationships
rowsRelatedTo: aRow
	| myWrapper relatedRows sourceField targetField allWrappers |
	"Note that we don't care which field, as presumably all of them must point the same place for a composite key, so grab the first pair"
	sourceField := self sourceFields first.
	targetField := self targetFields first.
	myWrapper := aRow wrapperAt: sourceField ifAbsent: [nil].
	myWrapper isNil ifTrue: [^#()].
	relatedRows := Set new: 5.
	allWrappers := OrderedCollection with: myWrapper.
	allWrappers addAll: myWrapper allInnerWrappers.
	allWrappers
		do: [:eachWrapper |
			(eachWrapper containedBy glorpAtIdentity: targetField ifAbsent: [#()])
				do: [:eachRow | eachRow == aRow ifFalse: [relatedRows add: eachRow]]].
	^relatedRows.