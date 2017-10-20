descriptors/other
descriptorForGlorpCompressedMoney: aDescriptor 
	| table currencyField amountField |
	table := self tableNamed: 'COMPRESSED_MONEY_TABLE'.
	aDescriptor 
		addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID')).
	currencyField := table fieldNamed: 'CURRENCY_NAME'.
	amountField := table fieldNamed: 'AMOUNT'.
	aDescriptor table: table.
	aDescriptor addMapping: (AdHocMapping 
				forAttribute: #array
				fromDb: 
					[:row :elementBuilder :context| 
					Array with: (elementBuilder valueOfField: (context translateField: currencyField) in: row)
						with: (elementBuilder valueOfField: (context translateField: amountField) in: row)]
				toDb: 
					[:rows :attribute :attributeRows | 
					(rows at: table) at: currencyField put: (attribute at: 1).
					(rows at: table) at: amountField put: (attribute at: 2)]
				mappingFields: (Array with: currencyField with: amountField)).
	"Note that position won't work if we have a join. We need to take the elementbuilder into account"
	^aDescriptor