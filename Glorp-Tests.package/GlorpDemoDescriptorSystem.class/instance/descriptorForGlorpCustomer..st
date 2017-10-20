descriptors/bank
descriptorForGlorpCustomer: aDescriptor

	| table |
	table := self tableNamed: 'GR_CUSTOMER'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #id to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) from: #name to: (table fieldNamed: 'NAME'); shouldProxy: true.
	(aDescriptor newMapping: ToManyMapping)
			attributeName: #transactions.
	(aDescriptor newMapping: ToManyMapping)
			attributeName: #accounts;
			useLinkTable.

	"Two additional relationships, there to test ordering within a mapping, where the order is determined by a field in the link table"
	(aDescriptor newMapping: ToManyMapping)
			attributeName: #accountsSortedById;
			readOnly: true;
			useLinkTable;
			orderBy: [:each | (each getTable: 'CUSTOMER_ACCT_LINK') getField: 'ACCT_ID'].
	(aDescriptor newMapping: ManyToManyMapping)
			attributeName: #accountsSortedByIdDescending;
			readOnly: true;
			useLinkTable;
			orderBy: [:each | ((each getTable: 'CUSTOMER_ACCT_LINK') getField: 'ACCT_ID') descending].