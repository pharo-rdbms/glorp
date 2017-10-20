private/mapping
instantiateIfRequiredForDeletedObjectReferencing: targetObject from: anObject in: aMapping
	"If we are deleted, then we need to have at least one mapping for each of our primary keys instantiated. If we're lucky, there's a direct mapping, and it's easy. Note that this only looks for the primary table. This might not be correct, but it's not clear, and for secondary tables there's a multiple table join that can be used without needing a mapping. And I'm not prepared to think about secondary tables whose keys are mapped only as relationships. In addition, if we use a link table, then we need to instantiate the reference, because we'll need to have enough information to delete the link table entry/entries."
	| mappingsToUseForPrimaryKeys |
	aMapping mapsPrimaryKeys ifFalse: [^false].	
	aMapping usesLinkTable ifTrue: [
		"Make sure we get the non-filtered version, and return false so that if the reference has changed, we'll also get the original version."
		self notFilteringDeletesDo: [targetObject yourSelf]. ^false].
	mappingsToUseForPrimaryKeys := aMapping descriptor primaryKeyMappingsFor: aMapping descriptor primaryTable.
	"For any of the fields we map, is there anyone else who can get us the value. If not, instantiate us. It might be better to optimize this a bit to look for e.g. one-one mappings before to-many."
	aMapping mappedFields do: [:each |
		| mappings |
		mappings := mappingsToUseForPrimaryKeys at: each ifAbsent: [nil].
		mappings isNil ifFalse: [
			(mappings allSatisfy: [:eachMapping | 
				(eachMapping hasValueThatCanProvideField: each from: anObject) not])
					ifTrue: [
						targetObject yourSelf.
						^true]]].
	^false