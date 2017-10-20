fields
addFields: aliasedFields returningTranslationForFields: originalFields distinct: isDistinct
	"The query has computed a set of fields the way the mappings see them, which are then transformed to account for field aliasing in embedded mappings. Add those to our collection, and set up the translation which knows which fields are at which index in the resulting row. If necessary, note that those fields are selected as distinct"

	| translation |
	translation := IdentityDictionary new.
	aliasedFields
		with: originalFields
		do:
			[:aliased :original | 
			| position fieldToAdd|
			position := self findPositionofAliasedField: aliased.
			position = 0
				ifTrue:  
					[fieldToAdd := isDistinct ifTrue: [aliased asDistinctFieldOn: self baseExpression] ifFalse: [aliased].
					fields add: fieldToAdd .
					position := fields size].
			translation at: original put: position].
	^translation