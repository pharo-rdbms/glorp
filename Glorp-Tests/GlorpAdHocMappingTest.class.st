Class {
	#name : #GlorpAdHocMappingTest,
	#superclass : #GlorpDatabaseBasedTest,
	#instVars : [
		'mapping',
		'person',
		'descriptor',
		'table',
		'money',
		'rowMap'
	],
	#category : 'Glorp-Tests-Tests'
}

{ #category : #tests }
GlorpAdHocMappingTest >> moneyNegatingMappingTo: amountField in: aDescriptor [ 
	mapping := aDescriptor newMapping: AdHocMapping.
	mapping
		forAttribute: #amount
		fromDb: [:row :elementBuilder :context | (elementBuilder valueOfField: (context translateField: amountField) in: row) negated]
		toDb: [:rows :attribute :attributeRows | (rows at: table) at: amountField put: attribute negated]
		mappingFields: (Array with: amountField).
	^mapping.
]

{ #category : #tests }
GlorpAdHocMappingTest >> testNegateMappingRead [
	| amountField inputRow builder |
	descriptor := system descriptorFor: GlorpMoney.
	table := system tableNamed: 'MONEY_IMAGINARY_TABLE'.
	amountField := table fieldNamed: 'AMOUNT'.
	mapping := self moneyNegatingMappingTo: amountField in: descriptor.
	descriptor addMapping: mapping.
	money := GlorpMoney basicNew.
	inputRow := #('US' 1).
	builder := ElementBuilder new.
	builder row: inputRow.
	mapping mapObject: money inElementBuilder: builder.
	self assert: money amount = -1.
]

{ #category : #tests }
GlorpAdHocMappingTest >> testNegateMappingWrite [
	| amountField outputRow |
	descriptor := system descriptorFor: GlorpMoney.
	table := system tableNamed: 'MONEY_IMAGINARY_TABLE'.
	amountField := table fieldNamed: 'AMOUNT'.
	mapping := self moneyNegatingMappingTo: amountField in: descriptor.
	descriptor table: table.
	descriptor addMapping: mapping.
	money := GlorpMoney forAmount: 3.
	rowMap := RowMap new.
	mapping mapFromObject: money intoRowsIn: rowMap.
	outputRow := rowMap rowForTable: table withKey: money.
	self assert: (outputRow at: (table fieldNamed: 'AMOUNT')) = -3
]

{ #category : #tests }
GlorpAdHocMappingTest >> testSplitMappingRead [
	| inputRow builder |
	money := GlorpCompressedMoney basicNew.
	mapping := (system descriptorFor: GlorpCompressedMoney)
		mappingForAttributeNamed: #array.
	inputRow := #(432 'US' 1).
	builder := ElementBuilder new.
	builder row: inputRow.
	mapping mapObject: money inElementBuilder: builder.
	self assert: money amount = 1.
	self assert: money currency = 'US'.
]

{ #category : #tests }
GlorpAdHocMappingTest >> testSplitMappingWrite [
	| outputRow |
	money := GlorpCompressedMoney currency: 'DM' amount: 99.
	mapping := (system descriptorFor: GlorpCompressedMoney) 
				mappingForAttributeNamed: #array.
	rowMap := RowMap new.
	mapping mapFromObject: money intoRowsIn: rowMap.
	table := mapping descriptor primaryTable.
	outputRow := rowMap rowForTable: table withKey: money.
	self assert: (outputRow at: (table fieldNamed: 'AMOUNT')) = 99.
	self assert: (outputRow at: (table fieldNamed: 'CURRENCY_NAME')) = 'DM'
]
