accessing
mappingsForFields
	"Return a dictionary from fields to the mappings that contain them. This specifically omits fields that are not in the selected set of tables (so e.g. even if a mapping uses a link table field, if it's not in the list of tables to select from, we don't want it). We also include mapped, non-constant expressions, which we would normally expect to be functions"
	mappingsForFields isNil ifTrue: [
		mappingsForFields := IdentityDictionary new: mappings size.
		mappings do: [:eachMapping | 
			eachMapping mappedFields do: [:eachField | 
				(mappingsForFields at: eachField ifAbsentPut: [OrderedCollection new]) add: eachMapping]]].
	^mappingsForFields.