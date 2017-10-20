descriptors
descriptorForGlorpVideoStore: aDescriptor

	| table |
	table := self tableNamed: 'VIDEO_STORE'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #id to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) from: #name to: (table fieldNamed: 'NAME').
	(aDescriptor newMapping: ToManyMapping)
			attributeName: #customers;
			join: (Join
				from: (table fieldNamed: 'ID')
				to: ((self tableNamed: 'VIDEO_CUSTOMER') fieldNamed: 'STORE_ID')).
	"The relationship to purchases is different from the one in customer, which distinguishes online from inStore"
	(aDescriptor newMapping: ToManyMapping)
		useLinkTable;
		attributeName: #purchases;
		constructRowMapKeyAs: [:store :purchase | 
					MultipleRowMapKey with: store with: purchase with: purchase customer yourself].
	"No relationship to rentals at all"