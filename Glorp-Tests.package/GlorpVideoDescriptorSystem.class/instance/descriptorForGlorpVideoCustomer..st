descriptors
descriptorForGlorpVideoCustomer: aDescriptor

	| table linkTable purchaseTable |
	table := self tableNamed: 'VIDEO_CUSTOMER'.
	linkTable := self tableNamed: 'VIDEO_PURCHASE_LINK'.
	purchaseTable := self tableNamed: 'VIDEO_PURCHASE'.

	aDescriptor table: table.

	(aDescriptor newMapping: DirectMapping) from: #name to: (table fieldNamed: 'CUSTOMERNAME').
	(aDescriptor newMapping: DirectMapping) from: #dateOfBirth to: (table fieldNamed: 'BIRTHDATE').

	(aDescriptor newMapping: OneToOneMapping)
			attributeName: #store.
	(aDescriptor newMapping: OneToOneMapping)
			attributeName: #creditStatus.
	(aDescriptor newMapping: ToManyMapping)
		attributeName: #inStoreRentals.
	(aDescriptor newMapping: ToManyMapping)
		useLinkTable;
		attributeName: #inStorePurchases;
		linkTableJoin: (Join 
			from: (table fieldNamed: 'STORE_ID')
			to: (linkTable fieldNamed: 'STORE_ID'));
		targetTableJoin: (Join
			from: (table fieldNamed: 'CUSTOMERNAME')
			to: (purchaseTable fieldNamed: 'CUSTOMERNAME')
			from: (table fieldNamed: 'BIRTHDATE')
			to: (purchaseTable fieldNamed: 'CUSTOMERBIRTHDATE')
			from: 'T'
			to: (purchaseTable fieldNamed: 'IN_STORE'));
			constructRowMapKeyAs: [:customer :purchase | 
					MultipleRowMapKey with: customer with: purchase with: customer videoStore yourself].

	(aDescriptor newMapping: ToManyMapping)
		useLinkTable;
		attributeName: #onlinePurchases;
		linkTableJoin: (Join 
			from: (table fieldNamed: 'STORE_ID')
			to: (linkTable fieldNamed: 'STORE_ID'));
		targetTableJoin: (Join 	
			from: (table fieldNamed: 'CUSTOMERNAME')
			to: (purchaseTable fieldNamed: 'CUSTOMERNAME')
			from: (table fieldNamed: 'BIRTHDATE')
			to: (purchaseTable fieldNamed: 'CUSTOMERBIRTHDATE')
			from: 'F'
			to: (purchaseTable fieldNamed: 'IN_STORE'));
			constructRowMapKeyAs: [:customer :purchase | 
					MultipleRowMapKey with: customer with: purchase with: customer videoStore yourself].

	"A complicated way of saying that the Store plus one other attribute has to be there"
	aDescriptor imaginaryTableIsDefinedByRelationFrom: #store to: #inStorePurchases.
	aDescriptor imaginaryTableIsDefinedByRelationFrom: #store to: #inStoreRentals.
	aDescriptor imaginaryTableIsDefinedByRelationFrom: #store to: #onlinePurchases.
	aDescriptor imaginaryTableIsDefinedByRelationFrom: #store to: #creditStatus.
	aDescriptor buildReplacementTableSelect.