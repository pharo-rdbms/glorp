converting
asQueryWithNullsForOtherClasses: aClass
	"Construct a specialized form of the query that's set up to retrieve instances of aClass, but with a bunch of empty fields that get populated with nulls, so we can retrieve several different classes at the same go."

	| newQuery nullField fieldsToIgnore markerExpression fieldsMinusTheConstant pseudoMappingName newBase tablesToIgnore |
	newQuery := self asSimpleQueryFor: aClass.	"We need to rebuild the where clause to refer to one of the subclass pseudo-mappings, because that's what we're retrieving. We don't want it against the actual class we're querying for, because we need the fields to be exactly the same for each of the sub-queries."
	pseudoMappingName := self descriptor typeResolver
		pseudoAttributeNameForClass: aClass.
	newBase := newQuery baseExpression get: pseudoMappingName.
	newBase bePhantom.
	newQuery where: (newQuery whereClause rebuildOn: newBase).	
	"We don't want it to try and retrieve the parent class. Instead, we alsoFetch: each of the subclasses, and insert a special builder that will select from among the valid results. To prevent it from trying to do anything with the main class itself, remove that from the tracing, and replace it with a special constant marker that we know will generate only one field, that we can remove later."
	newQuery tracing retrievalExpressions remove: newQuery tracing base.
	newQuery tracing allTracings remove: newQuery tracing base.
	markerExpression := ConstantExpression for: 'ignore me'.
	newQuery tracing retrievalExpressions add: markerExpression.
	newQuery tracing allTracings add: markerExpression.
	newQuery prepare.
	newQuery
		privateReplaceBuilderWith:
			(SelectingElementBuilder new expression: markerExpression).	
	"For each retrieval that isn't our class, change the fields being returned to nulls, and wrap a cast around them so that SQL doesn't complain. First, we figure out which fields those are."
	fieldsToIgnore := IdentityDictionary new.
	newQuery tracing alsoFetchExpressions
		do:
			[:each | 
			each mapping referenceClass = aClass
				ifFalse:
					[each fieldAliases
						do: [:eachFieldAlias | fieldsToIgnore at: eachFieldAlias put: each]]].	
	"Now we remove the constant field we know we caused to be generated earlier, and replace the others that we don't want with nulls"
	fieldsMinusTheConstant := newQuery fields
		copyFrom: 1
		to: newQuery fields size - 1.
	newQuery
		privateSetFields:
			(fieldsMinusTheConstant
				collect:
					[:eachField | 
					(fieldsToIgnore includesKey: eachField)
						ifFalse: [eachField]
						ifTrue:
							[nullField := self nullFieldFor: eachField.
							nullField]]).	
	"Supress all tables except the one(s) we actually want."
	newQuery prepare.
	tablesToIgnore := (fieldsToIgnore keys collect: [:each | each table]) asSet asArray.
	tablesToIgnore := tablesToIgnore, (newQuery baseExpression tablesToPrint).
	newQuery tablesToPrint: (newQuery tablesToPrint reject: [:each | tablesToIgnore includes: each]) asArray.	
	^newQuery