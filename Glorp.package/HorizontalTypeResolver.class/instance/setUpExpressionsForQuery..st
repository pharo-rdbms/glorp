query setup
setUpExpressionsForQuery: aQuery
	| mapping firstMapping allDescriptors |
	(self concreteMembers includes: aQuery resultClass) ifTrue: [^self].
	self shouldUseSingleQuery ifFalse: [^self].
	firstMapping := nil.
	allDescriptors := self
		descriptorsRequiringIndependentQueriesFor: aQuery resultClass.
	allDescriptors size = 1 ifTrue: [^self].
	allDescriptors
		do:
			[:eachSubclassDescriptor | 
			mapping := self
				mappingForSubclass: eachSubclassDescriptor
				connectTo: firstMapping.
			firstMapping isNil ifTrue: [firstMapping := mapping].
			aQuery
				alsoFetch:
					[:object | (object getMapping: mapping named: mapping attribute name) bePhantom asOuterJoin]]