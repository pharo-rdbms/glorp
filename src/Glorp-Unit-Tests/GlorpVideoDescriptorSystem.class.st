"
This descriptor system represents a video rental/sales store which sells both online and in a physical store. The interesting bit is that there is no customer table, but there is a customer object. In the database, orders and credit status are linked directly to the store. We synthesize a customer object out of those relationships.
"
Class {
	#name : #GlorpVideoDescriptorSystem,
	#superclass : #GlorpTestDescriptorSystem,
	#category : #'Glorp-Unit-Tests-Models - Video'
}

{ #category : #accessing }
GlorpVideoDescriptorSystem >> allTableNames [

	^ #( 'VIDEO_STORE' 'VIDEO_PURCHASE' 'VIDEO_RENTAL' 'VIDEO_PURCHASE_LINK'
	     'VIDEO_CUSTOMER' 'VIDEO_CREDIT_STATUS' )
]

{ #category : #'class models' }
GlorpVideoDescriptorSystem >> classModelForGlorpVideoCreditStatus: aClassModel [

	aClassModel
		newAttributeNamed: #customer type: GlorpVideoCustomer;
		newAttributeNamed: #store type: GlorpVideoStore;
		newAttributeNamed: #balanceOwing type: Number;
		newAttributeNamed: #dateOwing type: Date;
		newAttributeNamed: #comments type: String
]

{ #category : #'class models' }
GlorpVideoDescriptorSystem >> classModelForGlorpVideoCustomer: aClassModel [

	aClassModel
		newAttributeNamed: #name type: String;
		newAttributeNamed: #dateOfBirth type: Date;
		newAttributeNamed: #onlinePurchases collectionOf: GlorpVideoPurchase;
		newAttributeNamed: #inStorePurchases collectionOf: GlorpVideoPurchase;
		newAttributeNamed: #inStoreRentals collectionOf: GlorpVideoRental;
		newAttributeNamed: #store type: GlorpVideoStore;
		newAttributeNamed: #creditStatus type: GlorpVideoCreditStatus
]

{ #category : #'class models' }
GlorpVideoDescriptorSystem >> classModelForGlorpVideoPurchase: aClassModel [

	aClassModel
		newAttributeNamed: #id type: Integer;
		newAttributeNamed: #title type: String;
		newAttributeNamed: #price type: Number;
		newAttributeNamed: #inStore type: Boolean;
		newAttributeNamed: #customer type: GlorpVideoCustomer;
		newAttributeNamed: #store type: GlorpVideoStore
]

{ #category : #'class models' }
GlorpVideoDescriptorSystem >> classModelForGlorpVideoRental: aClassModel [

	aClassModel
		newAttributeNamed: #id type: Integer;
		newAttributeNamed: #title type: String;
		newAttributeNamed: #price type: Number;
		newAttributeNamed: #dueDate type: Date;
		newAttributeNamed: #customer type: GlorpVideoCustomer;
		newAttributeNamed: #store type: GlorpVideoStore
]

{ #category : #'class models' }
GlorpVideoDescriptorSystem >> classModelForGlorpVideoStore: aClassModel [

	aClassModel
		newAttributeNamed: #name type: String;
	  	newAttributeNamed: #purchases collectionOf: GlorpVideoPurchase;
	  	newAttributeNamed: #customers collectionOf: GlorpVideoCustomer
]

{ #category : #initialization }
GlorpVideoDescriptorSystem >> constructAllClasses [

	^(super constructAllClasses)
		add: GlorpVideoStore;
		add: GlorpVideoCreditStatus;
		add: GlorpVideoCustomer;
		add: GlorpVideoPurchase;
		add: GlorpVideoRental;
		yourself
]

{ #category : #descriptors }
GlorpVideoDescriptorSystem >> descriptorForGlorpVideoCreditStatus: aDescriptor [

	| table |
	table := self tableNamed: 'VIDEO_CREDIT_STATUS'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #balanceOwing to: (table fieldNamed: 'BALANCE').
	(aDescriptor newMapping: DirectMapping) from: #dateOwing to: (table fieldNamed: 'DATE_OWING').
	(aDescriptor newMapping: DirectMapping) from: #comments to: (table fieldNamed: 'COMMENTS').

	(aDescriptor newMapping: OneToOneMapping) attributeName: #customer
]

{ #category : #descriptors }
GlorpVideoDescriptorSystem >> descriptorForGlorpVideoCustomer: aDescriptor [

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
	aDescriptor buildReplacementTableSelect
]

{ #category : #descriptors }
GlorpVideoDescriptorSystem >> descriptorForGlorpVideoPurchase: aDescriptor [

	| table |
	table := self tableNamed: 'VIDEO_PURCHASE'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #id to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) from: #title to: (table fieldNamed: 'TITLE').
	(aDescriptor newMapping: DirectMapping) from: #price to: (table fieldNamed: 'PRICE').
	(aDescriptor newMapping: DirectMapping) from: #inStore to: (table fieldNamed: 'IN_STORE').

	(aDescriptor newMapping: OneToOneMapping)
			useLinkTable;
			attributeName: #store;
			constructRowMapKeyAs: [:purchase :store |
					MultipleRowMapKey with: purchase with: store with: purchase customer yourself].

	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #customer
]

{ #category : #descriptors }
GlorpVideoDescriptorSystem >> descriptorForGlorpVideoRental: aDescriptor [

	| table |
	table := self tableNamed: 'VIDEO_RENTAL'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #id to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) from: #title to: (table fieldNamed: 'TITLE').
	(aDescriptor newMapping: DirectMapping) from: #dueDate to: (table fieldNamed: 'DUE_DATE').
	(aDescriptor newMapping: DirectMapping) from: #price to: (table fieldNamed: 'PRICE').
	(aDescriptor newMapping: DirectMapping) fromPseudoVariable: #customerName to: (table fieldNamed: 'CUSTOMERNAME').

	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #customer.
	(aDescriptor newMapping: OneToOneMapping)
			attributeName: #store
]

{ #category : #descriptors }
GlorpVideoDescriptorSystem >> descriptorForGlorpVideoStore: aDescriptor [

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
]

{ #category : #examples }
GlorpVideoDescriptorSystem >> exampleCreditStatus1 [

	| example |
	example := GlorpVideoCreditStatus new.
	example balanceOwing: 12.00.
	example dateOwing: (Date today addDays: -1).
	example comments: 'One'.
	^ example
]

{ #category : #examples }
GlorpVideoDescriptorSystem >> exampleCreditStatus2 [

	| example |
	example := GlorpVideoCreditStatus new.
	example balanceOwing: 22.00.
	example dateOwing: (Date today addDays: -1).
	example comments: 'Two'.
	^ example
]

{ #category : #examples }
GlorpVideoDescriptorSystem >> exampleCreditStatus3 [

	| example |
	example := GlorpVideoCreditStatus new.
	example balanceOwing: 33.00.
	example dateOwing: (Date today addDays: -1).
	example comments: 'Three'.
	^ example
]

{ #category : #examples }
GlorpVideoDescriptorSystem >> exampleCustomer1 [
	"A customer with only online purchases"
	| customer |
	customer := GlorpVideoCustomer new.
	customer name: 'Adrian'.
	customer dateOfBirth: (Date today subtractDays: (10 * 365)).
	customer addOnlinePurchase: self exampleOnlinePurchase1.
	customer addOnlinePurchase: self exampleOnlinePurchase2.
	^customer.
]

{ #category : #examples }
GlorpVideoDescriptorSystem >> exampleCustomer2 [
	"A customer with only inStore purchases"
	| customer |
	customer := GlorpVideoCustomer new.
	customer name: 'Bob'.
	customer dateOfBirth: (Date today subtractDays: (20 * 365)).
	customer addInStorePurchase: self exampleInStorePurchase1.
	^customer.
]

{ #category : #examples }
GlorpVideoDescriptorSystem >> exampleCustomer3 [
	"A customer with only rentals"
	| customer |
	customer := GlorpVideoCustomer new.
	customer name: 'Carol'.
	customer dateOfBirth: (Date today subtractDays: (30 * 365)).
	customer addRental: self exampleInStoreRental1.
	^customer.
]

{ #category : #examples }
GlorpVideoDescriptorSystem >> exampleCustomer4 [
	"A customer with only credit"
	| customer |
	customer := GlorpVideoCustomer new.
	customer name: 'David'.
	customer dateOfBirth: (Date today subtractDays: (40 * 365)).
	customer creditStatus: self exampleCreditStatus1.
	^customer.
]

{ #category : #examples }
GlorpVideoDescriptorSystem >> exampleCustomer5 [
	"A customer with purchases and rentals"

	| customer |
	customer := GlorpVideoCustomer new.
	customer name: 'Eleanor'.
	customer dateOfBirth: (Date today subtractDays: 50 * 365).
	customer addInStorePurchase: self exampleInStorePurchase2.
	customer addInStorePurchase: self exampleInStorePurchase3.
	customer addRental: self exampleInStoreRental2.
	^customer.
]

{ #category : #examples }
GlorpVideoDescriptorSystem >> exampleCustomer6 [
	"A customer with purchases and credit"

	| customer |
	customer := GlorpVideoCustomer new.
	customer name: 'Francois'.
	customer dateOfBirth: (Date today subtractDays: 60 * 365).
	customer addInStorePurchase: self exampleInStorePurchase4.
	customer addInStorePurchase: self exampleInStorePurchase5.
	customer creditStatus: self exampleCreditStatus2.
	^customer.
]

{ #category : #examples }
GlorpVideoDescriptorSystem >> exampleCustomer7 [
	"A customer with everything"

	| customer |
	customer := GlorpVideoCustomer new.
	customer name: 'George'.
	customer dateOfBirth: (Date today subtractDays: 70 * 365).
	customer addInStorePurchase: self exampleInStorePurchase6.
	customer addOnlinePurchase: self exampleOnlinePurchase3.
	customer addRental: self exampleInStoreRental3.
	customer addRental: self exampleInStoreRental4.
	customer creditStatus: self exampleCreditStatus3.
	^customer.
]

{ #category : #examples }
GlorpVideoDescriptorSystem >> exampleCustomer8 [
	"A customer with just a single purchase"

	| customer |
	customer := GlorpVideoCustomer new.
	customer name: 'Hieronymous'.
	customer dateOfBirth: (Date today subtractDays: 80 * 365).
	customer addInStorePurchase: self exampleInStorePurchase7.
	^customer.
]

{ #category : #examples }
GlorpVideoDescriptorSystem >> exampleInStorePurchase1 [
	| purchase |
	purchase := GlorpVideoPurchase new.
	purchase id: 101.
	purchase title: 'An American in Paris'.
	purchase price: 1.00.
	purchase inStore: true.
	^purchase.
]

{ #category : #examples }
GlorpVideoDescriptorSystem >> exampleInStorePurchase2 [
	| purchase |
	purchase := GlorpVideoPurchase new.
	purchase id: 102.
	purchase title: 'Brazil'.
	purchase price: 2.00.
	purchase inStore: true.
	^purchase.
]

{ #category : #examples }
GlorpVideoDescriptorSystem >> exampleInStorePurchase3 [
	| purchase |
	purchase := GlorpVideoPurchase new.
	purchase id: 103.
	purchase title: 'Cambodia, Swimming To'.
	purchase price: 3.00.
	purchase inStore: true.
	^purchase.
]

{ #category : #examples }
GlorpVideoDescriptorSystem >> exampleInStorePurchase4 [
	| purchase |
	purchase := GlorpVideoPurchase new.
	purchase id: 104.
	purchase title: 'Dogma'.
	purchase price: 4.00.
	purchase inStore: true.
	^purchase.
]

{ #category : #examples }
GlorpVideoDescriptorSystem >> exampleInStorePurchase5 [
	| purchase |
	purchase := GlorpVideoPurchase new.
	purchase id: 105.
	purchase title: 'ET'.
	purchase price: 5.00.
	purchase inStore: true.
	^purchase.
]

{ #category : #examples }
GlorpVideoDescriptorSystem >> exampleInStorePurchase6 [
	| purchase |
	purchase := GlorpVideoPurchase new.
	purchase id: 106.
	purchase title: 'Fargo'.
	purchase price: 6.00.
	purchase inStore: true.
	^purchase.
]

{ #category : #examples }
GlorpVideoDescriptorSystem >> exampleInStorePurchase7 [
	| purchase |
	purchase := GlorpVideoPurchase new.
	purchase id: 107.
	purchase title: 'Glengarry GlenRoss'.
	purchase price: 7.00.
	purchase inStore: true.
	^purchase.
]

{ #category : #examples }
GlorpVideoDescriptorSystem >> exampleInStoreRental1 [
	| rental |
	rental := GlorpVideoRental new.
	rental id: 1001.
	rental title: 'Amelie'.
	rental price: 21.00.
	rental dueDate: Date today.
	^rental.
]

{ #category : #examples }
GlorpVideoDescriptorSystem >> exampleInStoreRental2 [
	| rental |
	rental := GlorpVideoRental new.
	rental id: 1002.
	rental title: 'Best in Show'.
	rental price: 22.00.
	rental dueDate: Date today.
	^rental.
]

{ #category : #examples }
GlorpVideoDescriptorSystem >> exampleInStoreRental3 [
	| rental |
	rental := GlorpVideoRental new.
	rental id: 1003.
	rental title: 'Charlie Brown Christmas'.
	rental price: 23.00.
	rental dueDate: Date today.
	^rental.
]

{ #category : #examples }
GlorpVideoDescriptorSystem >> exampleInStoreRental4 [
	| rental |
	rental := GlorpVideoRental new.
	rental id: 1004.
	rental title: 'Down By Law'.
	rental price: 24.00.
	rental dueDate: Date today.
	^rental.
]

{ #category : #examples }
GlorpVideoDescriptorSystem >> exampleOnlinePurchase1 [
	| purchase |
	purchase := GlorpVideoPurchase new.
	purchase id: 1.
	purchase title: 'All About Eve'.
	purchase price: 1.11.
	purchase inStore: false.
	^purchase.
]

{ #category : #examples }
GlorpVideoDescriptorSystem >> exampleOnlinePurchase2 [
	| purchase |
	purchase := GlorpVideoPurchase new.
	purchase id: 2.
	purchase title: 'Butch Cassidy and the Sundance Kid'.
	purchase price: 2.22.
	purchase inStore: false.
	^purchase.
]

{ #category : #examples }
GlorpVideoDescriptorSystem >> exampleOnlinePurchase3 [
	| purchase |
	purchase := GlorpVideoPurchase new.
	purchase id: 3.
	purchase title: 'Cabaret'.
	purchase price: 3.33.
	purchase inStore: false.
	^purchase.
]

{ #category : #examples }
GlorpVideoDescriptorSystem >> exampleStore1 [
	"self new exampleStore1"
	| example |
	example := GlorpVideoStore new.
	example name: 'Als Video'.
	example id: 1.
	example customers: (Array with: self exampleCustomer1 with: self exampleCustomer2 with: self exampleCustomer3 with: self exampleCustomer4), (Array with: self exampleCustomer5 with: self exampleCustomer6 with: self exampleCustomer7).
	example computeCollections.
	^example.
]

{ #category : #examples }
GlorpVideoDescriptorSystem >> exampleStore2 [
	"self new exampleStore2"
	| example |
	example := GlorpVideoStore new.
	example name: 'Bonzai Video'.
	example id: 2.
	example customers: (Array with: self exampleCustomer8).
	example computeCollections.
	^example.
]

{ #category : #tables }
GlorpVideoDescriptorSystem >> tableForVIDEO_CREDIT_STATUS: aTable [
	| customerTable custName custDate storeId |
	customerTable := self tableNamed: 'VIDEO_CUSTOMER'.
	custName := (aTable createFieldNamed: 'CUSTOMERNAME' type: (platform varchar: 50))
		bePrimaryKey.
	custDate := (aTable createFieldNamed: 'CUSTOMERBIRTHDATE' type: platform date) bePrimaryKey.
	storeId := (aTable createFieldNamed: 'STORE_ID' type: platform int4) bePrimaryKey.
	aTable addForeignKeyFrom: custName
		to: (customerTable fieldNamed: 'CUSTOMERNAME')
		from: custDate
		to: (customerTable fieldNamed: 'BIRTHDATE')
		from: storeId
		to: (customerTable fieldNamed: 'STORE_ID') .
	aTable addForeignKeyFrom: storeId to: ((self tableNamed: 'VIDEO_STORE') fieldNamed: 'ID').

	aTable createFieldNamed: 'BALANCE' type: (platform double).
	aTable createFieldNamed: 'DATE_OWING' type: platform date.
	aTable createFieldNamed: 'COMMENTS' type: (platform varchar: 50).
]

{ #category : #tables }
GlorpVideoDescriptorSystem >> tableForVIDEO_CUSTOMER: aTable [
	"Note: This table is imaginary"
	| storeId |
	aTable isImaginary: true.
	(aTable createFieldNamed: 'CUSTOMERNAME' type: (platform varchar: 50))
		bePrimaryKey.
	(aTable createFieldNamed: 'BIRTHDATE' type: platform date) bePrimaryKey.
	storeId := (aTable createFieldNamed: 'STORE_ID' type: (platform int4)) bePrimaryKey.
	aTable addForeignKeyFrom: storeId
		to: ((self tableNamed: 'VIDEO_STORE') fieldNamed: 'ID')
]

{ #category : #tables }
GlorpVideoDescriptorSystem >> tableForVIDEO_PURCHASE: aTable [
	| custName custDate customerTable |
	(aTable createFieldNamed: 'ID' type: (platform int4)) bePrimaryKey.
	customerTable := self tableNamed: 'VIDEO_CUSTOMER'.
	custName := aTable createFieldNamed: 'CUSTOMERNAME' type: (platform varchar: 50).
	custDate := aTable createFieldNamed: 'CUSTOMERBIRTHDATE' type: platform date.
	aTable addForeignKeyFrom: custName
		to: (customerTable fieldNamed: 'CUSTOMERNAME')
		from: custDate
		to: (customerTable fieldNamed: 'BIRTHDATE').

	aTable createFieldNamed: 'TITLE' type: (platform varchar: 50).	
	aTable createFieldNamed: 'PRICE' type: (platform double).
	aTable createFieldNamed: 'IN_STORE' type: (platform char: 1).
]

{ #category : #tables }
GlorpVideoDescriptorSystem >> tableForVIDEO_PURCHASE_LINK: aTable [
	| storeId purchaseId |
	purchaseId := aTable createFieldNamed: 'PURCHASE_ID' type: platform int4.
	storeId := aTable createFieldNamed: 'STORE_ID' type: (platform int4).
	aTable addForeignKeyFrom: storeId
		to: ((self tableNamed: 'VIDEO_STORE') fieldNamed: 'ID').
	aTable addForeignKeyFrom: purchaseId
		to: ((self tableNamed: 'VIDEO_PURCHASE') fieldNamed: 'ID').
]

{ #category : #tables }
GlorpVideoDescriptorSystem >> tableForVIDEO_RENTAL: aTable [
	| custName custDate storeId customerTable |
	(aTable createFieldNamed: 'ID' type: (platform int4)) bePrimaryKey.
	customerTable := self tableNamed: 'VIDEO_CUSTOMER'.
	custName := aTable createFieldNamed: 'CUSTOMERNAME' type: (platform varchar: 50).
	custDate := aTable createFieldNamed: 'CUSTOMERBIRTHDATE' type: platform date.
	storeId := aTable createFieldNamed: 'STORE_ID' type: (platform int4).
	aTable addForeignKeyFrom: custName
		to: (customerTable fieldNamed: 'CUSTOMERNAME')
		from: custDate
		to: (customerTable fieldNamed: 'BIRTHDATE')
		from: storeId
		to: (customerTable fieldNamed: 'STORE_ID').
	aTable addForeignKeyFrom: storeId to: ((self tableNamed: 'VIDEO_STORE') fieldNamed: 'ID').

	aTable createFieldNamed: 'TITLE' type: (platform varchar: 50).	
	aTable createFieldNamed: 'DUE_DATE' type: platform date.
	aTable createFieldNamed: 'PRICE' type: (platform double).
]

{ #category : #tables }
GlorpVideoDescriptorSystem >> tableForVIDEO_STORE: aTable [
	(aTable createFieldNamed: 'ID' type: (platform int4)) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varchar: 20).
]
