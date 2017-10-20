private/mapping
instantiateIfRequiredFor: anObject mapping: eachMapping
	"Sometimes we have to instantiate the targets if they weren't. Specifically, if there's a relationship where the target has a foreign key to us. e.g. if X has a 1-many to Y, and we don't instantiate the collection of Y, but then replace it with some other collection. The Y's keys have to be updated, so we need to make sure they're read. There are other cases, too"

	| originalTarget targetObject mapping instantiated |
	mapping := eachMapping applicableMappingForObject: anObject.
	mapping isRelationship ifFalse: [^false].
	mapping readOnly ifTrue: [^false].
	targetObject := mapping getValueFrom: anObject.
	(self isNewObject: anObject)
		ifTrue:
			[^self instantiateIfRequiredForNewObjectReferenceTo: targetObject].
	instantiated := (self willDelete: anObject)
		ifTrue:
			[self instantiateIfRequiredForDeletedObjectReferencing: targetObject from: anObject in: eachMapping]
		ifFalse: [false].
	originalTarget := self originalValueFor: anObject mapping: mapping.
	^instantiated or: [self
		instantiateIfRequiredForReferenceChangedFrom: originalTarget
		to: targetObject]