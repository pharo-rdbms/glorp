accessing
mappedFields
	"Return all the fields that are mapped, in the order that they occur in the table. This specifically omits fields that are not in the selected set of tables (so e.g. even if a mapping uses a link table field, if it's not in the list of tables to select from, we don't want it). We also include mapped, non-constant expressions, which we would normally expect to be functions"
	mappedFields isNil ifTrue: [
		| fieldSet |
		fieldSet := IdentitySet new: mappings size.
		mappings do: [:each | fieldSet addAll: each fieldsForDescriptorSelectStatement].
		mappedFields := OrderedCollection new.
		tables do: [:each |
			each fields do: [:eachField | (fieldSet includes: eachField) ifTrue: [mappedFields add: eachField]]].
		fieldSet do: [:each | 
 			(each isGlorpExpression and: [each isConstantExpression not]) ifTrue: [mappedFields add: each]]].
	^mappedFields.