deletion
computeCollectionDeletesFor: aMapping inObject: anObject
	"Figure out which, if any, dependent objects we should delete based on changes to the corresponding collection in anObject"
	| collection memento collectionMemento |
	aMapping isExclusive ifFalse: [^self].
	aMapping attribute isCollectionAttribute ifFalse: [^self].
	collection := aMapping getValueFrom: anObject.
	collection := self session realObjectFor: collection ifNone: [^self].
	(aMapping isValidTarget: collection) ifFalse: [^self].
	memento := transaction mementoFor: anObject.
	collectionMemento := transaction collectionMementoFor: (self session realObjectFor: (aMapping getValueFrom: memento)).
	"OK, now we have the state of the original collection and the new collection, we can look for differences."
	collectionMemento do: [:each |
		| matching |
		(each isGlorpProxy not or: [each isInstantiated]) ifTrue: [
			matching := collection 
				detect: [:eachElement | 
					(eachElement isGlorpProxy not or: [eachElement isInstantiated])
						and: [each yourSelf == eachElement yourSelf]]
				ifNone: [nil].
			matching == nil ifTrue: [session delete: each]
		]
	]