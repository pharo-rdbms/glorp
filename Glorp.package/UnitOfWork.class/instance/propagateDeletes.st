begin/commit/abort
propagateDeletes
	"If we have objects which are to be deleted, and they have exclusive relationships to other objects, then we must also delete those other objects."
	| deletionQueue |
	deletionQueue := OrderedCollection new: deletedObjects size.
	deletionQueue addAll: deletedObjects.
	[deletionQueue isEmpty]
		whileFalse:
			[| each |
			each := deletionQueue removeFirst.
			(self session descriptorFor: each) mappings
				do:
					[:eachMapping | 
					eachMapping isExclusive
						ifTrue:
							[eachMapping
								loopOverAttributeOf: each
								doing:
									[:index :subObject | 
									| realSubObject |
									realSubObject := subObject yourSelf.
									(realSubObject notNil and: [(deletedObjects includes: realSubObject) not])
										ifTrue:
											[session delete: subObject.
											deletionQueue add: realSubObject]]]]]