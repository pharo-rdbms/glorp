"
This is the same as the demo descriptor system, but with small modifications to use link tables in different places.


"
Class {
	#name : #GlorpLinkTableAnywhereDescriptorSystem,
	#superclass : #GlorpDemoDescriptorSystem,
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #'descriptors/bank' }
GlorpLinkTableAnywhereDescriptorSystem >> classModelForGlorpCustomer: aClassModel [
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #name.
	aClassModel newAttributeNamed: #transactions collectionOf: GlorpBankTransaction.
	"Note: accounts is a 1-1 in this model"
	aClassModel newAttributeNamed: #accounts type: GlorpBankAccount.
	aClassModel newAttributeNamed: #accountsSortedById collectionOf: GlorpBankAccount.
	aClassModel newAttributeNamed: #accountsSortedByIdDescending collectionOf: GlorpBankAccount.
]

{ #category : #'descriptors/bank' }
GlorpLinkTableAnywhereDescriptorSystem >> descriptorForGlorpCustomer: aDescriptor [

	| table |
	table := self tableNamed: 'GR_CUSTOMER'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #id to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) from: #name to: (table fieldNamed: 'NAME').
	(aDescriptor newMapping: OneToManyMapping)
			attributeName: #transactions;
			referenceClass: GlorpBankTransaction.
	(aDescriptor newMapping: OneToOneMapping)
			attributeName: #accounts;
			referenceClass: GlorpBankAccount;
			usesLinkTable: true.
]
