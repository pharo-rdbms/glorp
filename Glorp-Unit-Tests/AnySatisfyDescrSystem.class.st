"
This is a system for testing nested #anySatisfy: blocks.

"
Class {
	#name : #AnySatisfyDescrSystem,
	#superclass : #GlorpTestDescriptorSystem,
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #accessing }
AnySatisfyDescrSystem >> allTableNames [

	^#('ASCUSTOMER' 'ASORDER' 'ASORDERLINEITEM' 'ASITEM' 'ASITEMBONUS' 'ASBONUS').
]

{ #category : #accessing }
AnySatisfyDescrSystem >> classModelForASBonus: aClassModel [
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #name.
	aClassModel newAttributeNamed: #credits
]

{ #category : #accessing }
AnySatisfyDescrSystem >> classModelForASCustomer: aClassModel [
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #name.
	aClassModel newAttributeNamed: #orders collectionOf: ASOrder.
]

{ #category : #accessing }
AnySatisfyDescrSystem >> classModelForASItem: aClassModel [
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #name.
	aClassModel newAttributeNamed: #bonuses collectionOf: ASItemBonus.
]

{ #category : #accessing }
AnySatisfyDescrSystem >> classModelForASItemBonus: aClassModel [
	aClassModel newAttributeNamed: #item type: ASItem.
	aClassModel newAttributeNamed: #bonus type: ASBonus.
]

{ #category : #accessing }
AnySatisfyDescrSystem >> classModelForASOrder: aClassModel [
	aClassModel newAttributeNamed: #orderNo.
	aClassModel newAttributeNamed: #customer type: ASCustomer.
	aClassModel newAttributeNamed: #lineItems collectionOf: ASOrderLineItem.
]

{ #category : #accessing }
AnySatisfyDescrSystem >> classModelForASOrderLineItem: aClassModel [
	aClassModel newAttributeNamed: #posNo.
	aClassModel newAttributeNamed: #item type: ASItem.
	aClassModel newAttributeNamed: #order type: ASOrder.
	aClassModel newAttributeNamed: #quantity.
	aClassModel newAttributeNamed: #price.
]

{ #category : #accessing }
AnySatisfyDescrSystem >> descriptorForASBonus: aDescriptor [
	| table |
	table := self tableNamed: 'ASBONUS'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping)
		from: #id
		to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping)
		from: #name
		to: (table fieldNamed: 'NAME').
	(aDescriptor newMapping: DirectMapping)
		from: #credits
		to: (table fieldNamed: 'CREDITS').
]

{ #category : #accessing }
AnySatisfyDescrSystem >> descriptorForASCustomer: aDescriptor [
	| table |
	table := self tableNamed: 'ASCUSTOMER'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping)
		from: #id
		to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping)
		from: #name
		to: (table fieldNamed: 'NAME').
	(aDescriptor newMapping: OneToManyMapping)
		attributeName: #orders.
]

{ #category : #accessing }
AnySatisfyDescrSystem >> descriptorForASItem: aDescriptor [
	| table |
	table := self tableNamed: 'ASITEM'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping)
		from: #id
		to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping)
		from: #name
		to: (table fieldNamed: 'NAME').
	(aDescriptor newMapping: OneToManyMapping)
		attributeName: #bonuses.
]

{ #category : #accessing }
AnySatisfyDescrSystem >> descriptorForASItemBonus: aDescriptor [
	| table newMapping join |
	table := self tableNamed: 'ASITEMBONUS'.
	aDescriptor table: table.

	newMapping := aDescriptor newMapping: OneToOneMapping.
	newMapping attributeName: #item.
	join := Join new.
	join
		from: (table fieldNamed: 'ITEMID')
		to: ((self tableNamed: 'ASITEM') fieldNamed: 'ID').
	newMapping join: join.

	newMapping := aDescriptor newMapping: OneToOneMapping.
	newMapping attributeName: #bonus.
	join := Join new.
	join
		from: (table fieldNamed: 'BONUSID')
		to: ((self tableNamed: 'ASBONUS') fieldNamed: 'ID').
	newMapping join: join.
]

{ #category : #accessing }
AnySatisfyDescrSystem >> descriptorForASOrder: aDescriptor [
	| table newMapping join |
	table := self tableNamed: 'ASORDER'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping)
		from: #orderNo
		to: (table fieldNamed: 'ORDERNO').
	(aDescriptor newMapping: OneToManyMapping)
		attributeName: #lineItems.
	newMapping := aDescriptor newMapping: OneToOneMapping.
	newMapping attributeName: #customer.
	join := Join new.
	join
		from: (table fieldNamed: 'CUSTOMERID')
		to: ((self tableNamed: 'ASCUSTOMER') fieldNamed: 'ID').
	newMapping join: join.
]

{ #category : #accessing }
AnySatisfyDescrSystem >> descriptorForASOrderLineItem: aDescriptor [
	| table newMapping join |
	table := self tableNamed: 'ASORDERLINEITEM'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping)
		from: #posNo
		to: (table fieldNamed: 'POSNO').
	(aDescriptor newMapping: DirectMapping)
		from: #quantity
		to: (table fieldNamed: 'QUANTITY').
	(aDescriptor newMapping: DirectMapping)
		from: #price
		to: (table fieldNamed: 'PRICE').

	newMapping := aDescriptor newMapping: OneToOneMapping.
	newMapping attributeName: #order.
	join := Join new.
	join
		from: (table fieldNamed: 'ORDERORDERNO')
		to: ((self tableNamed: 'ASORDER') fieldNamed: 'ORDERNO').
	newMapping join: join.

	newMapping := aDescriptor newMapping: OneToOneMapping.
	newMapping attributeName: #item.
	join := Join new.
	join
		from: (table fieldNamed: 'ITEMID')
		to: ((self tableNamed: 'ASITEM') fieldNamed: 'ID').
	newMapping join: join.
]

{ #category : #accessing }
AnySatisfyDescrSystem >> tableForASBONUS: aTable [

	(aTable createFieldNamed: 'ID' type: platform integer) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 20).
	aTable createFieldNamed: 'CREDITS' type: (platform integer).
]

{ #category : #accessing }
AnySatisfyDescrSystem >> tableForASCUSTOMER: aTable [

	(aTable createFieldNamed: 'ID' type: platform integer) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 20).
]

{ #category : #accessing }
AnySatisfyDescrSystem >> tableForASITEM: aTable [

	(aTable createFieldNamed: 'ID' type: platform integer) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 20).
]

{ #category : #accessing }
AnySatisfyDescrSystem >> tableForASITEMBONUS: aTable [

	| field |

	field := aTable createFieldNamed: 'ITEMID' type: platform integer.
	aTable addForeignKeyFrom: field to: ((self tableNamed: 'ASITEM') fieldNamed: 'ID').
	field bePrimaryKey.

	field := aTable createFieldNamed: 'BONUSID' type: platform integer.
	aTable addForeignKeyFrom: field to: ((self tableNamed: 'ASBONUS') fieldNamed: 'ID').
]

{ #category : #accessing }
AnySatisfyDescrSystem >> tableForASORDER: aTable [

	| field |

	(aTable createFieldNamed: 'ORDERNO' type: platform integer) bePrimaryKey.
	field := aTable createFieldNamed: 'CUSTOMERID' type: platform integer.
	aTable addForeignKeyFrom: field to: ((self tableNamed: 'ASCUSTOMER') fieldNamed: 'ID').
]

{ #category : #accessing }
AnySatisfyDescrSystem >> tableForASORDERLINEITEM: aTable [

	| field |

	(aTable createFieldNamed: 'POSNO' type: platform integer) bePrimaryKey.
	aTable createFieldNamed: 'QUANTITY' type: (platform number precision: 9; scale: 4; yourself).
	aTable createFieldNamed: 'PRICE' type: (platform number precision: 9; scale: 4; yourself).

	field := aTable createFieldNamed: 'ORDERORDERNO' type: platform integer.
	aTable addForeignKeyFrom: field to: ((self tableNamed: 'ASORDER') fieldNamed: 'ORDERNO').
	field bePrimaryKey.

	field := aTable createFieldNamed: 'ITEMID' type: platform integer.
	aTable addForeignKeyFrom: field to: ((self tableNamed: 'ASITEM') fieldNamed: 'ID').
]
