tests
moneyNegatingMappingTo: amountField in: aDescriptor 
	mapping := aDescriptor newMapping: AdHocMapping.
	mapping
		forAttribute: #amount
		fromDb: [:row :elementBuilder :context | (elementBuilder valueOfField: (context translateField: amountField) in: row) negated]
		toDb: [:rows :attribute :attributeRows | (rows at: table) at: amountField put: attribute negated]
		mappingFields: (Array with: amountField).
	^mapping.