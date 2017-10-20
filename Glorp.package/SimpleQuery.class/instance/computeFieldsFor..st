executing
computeFieldsFor: anElementBuilder 
	| translatedFields |
	translatedFields := self 
		addFields: anElementBuilder fieldsForSelectStatement
		returningTranslationForFields: anElementBuilder fieldsFromMyPerspective
		distinct: anElementBuilder requiresDistinct.
	anElementBuilder fieldTranslations: translatedFields