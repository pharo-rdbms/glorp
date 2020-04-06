Class {
	#name : #GlorpUnitOfWorkTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'session'
	],
	#category : 'Glorp-Tests-Database'
}

{ #category : #resources }
GlorpUnitOfWorkTest class >> resources [

	^Array with: GlorpSessionResource.
]

{ #category : #support }
GlorpUnitOfWorkTest >> exampleCustomerProxy [
	| p |
	p := Proxy new.
	p session: session.
	p query: (GlorpQueryStub readOneOf: GlorpCustomer where: [:a | a id = 3]).
	p query result: (GlorpCustomer new id: 3).
	^p
]

{ #category : #support }
GlorpUnitOfWorkTest >> exampleCustomerWithTransactionsProxy [
	| customer |
	customer := GlorpCustomer new.
	customer transactions: self exampleTransactionsProxy.
	^customer
]

{ #category : #support }
GlorpUnitOfWorkTest >> exampleTransactionWithCustomerProxy [
	| transaction |
	transaction := GlorpBankTransaction example1.
	transaction owner: self exampleCustomerProxy.
	^transaction
]

{ #category : #support }
GlorpUnitOfWorkTest >> exampleTransactionsProxy [
	| p |
	p := Proxy new.
	p session: session.
	p query: (GlorpQueryStub readOneOf: GlorpBankTransaction where: [:a | a id ~= 0]).
	p query result: (Array with: GlorpBankTransaction example1 with: GlorpBankTransaction example1).
	^p
]

{ #category : #support }
GlorpUnitOfWorkTest >> setUp [
	super setUp.
	session := GlorpSessionResource current newSession.
]

{ #category : #support }
GlorpUnitOfWorkTest >> tearDown [
	super tearDown.
	session reset.
	session resetPermissions.
	session := nil.
]

{ #category : #tests }
GlorpUnitOfWorkTest >> testAutomaticRegistrationOnRead [
	| p c |
	p := self exampleCustomerProxy.
	c := p getValue.
	session beginUnitOfWork.
	session register: p.
	self assert: (session isRegistered: p).
	self assert: (session isRegistered: c).
	self assert: (session privateGetCurrentUnitOfWork privateGetTransaction isRegistered: p).
	self assert: (session privateGetCurrentUnitOfWork privateGetTransaction isRegistered: c).
]

{ #category : #tests }
GlorpUnitOfWorkTest >> testCheckIfInstantiationRequiredForDirectMapping [
	| c1 mapping proxy |
	c1 := GlorpCustomer new.
	proxy := Proxy new.
	c1 name: proxy.
	session beginUnitOfWork.
	session register: c1.
	mapping := (session descriptorFor: GlorpCustomer) mappingForAttributeNamed: #name.
	self deny: (session privateGetCurrentUnitOfWork instantiateIfRequiredFor: c1 mapping: mapping).
]

{ #category : #tests }
GlorpUnitOfWorkTest >> testCheckIfInstantiationRequiredForRelationshipInstantiatedProxy [
	| c1 mapping proxy |
	c1 := GlorpCustomer new.
	proxy := Proxy new.
	proxy query: (GlorpQueryStub new session: session; result: 'foo').
	proxy session: session.
	proxy yourSelf.
	c1 accounts: proxy.
	session beginUnitOfWork.
	session register: c1.
	c1 accounts: #().
	mapping := (session descriptorFor: GlorpCustomer) mappingForAttributeNamed: #accounts.
	self deny: (session privateGetCurrentUnitOfWork instantiateIfRequiredFor: c1 mapping: mapping).
]

{ #category : #tests }
GlorpUnitOfWorkTest >> testCheckIfInstantiationRequiredForRelationshipNoChange [
	"Note that we explicitly register the objects as being old (even though they aren't) so that we don't force instantation of the related objects, which is what we're trying to test."
	| c1 mapping proxy |
	c1 := GlorpCustomer new.
	proxy := Proxy new.
	c1 accounts: proxy.
	session beginUnitOfWork.
	session privateRegisterAsOld: c1.
	mapping := (session descriptorFor: GlorpCustomer) mappingForAttributeNamed: #accounts.
	self deny: (session privateGetCurrentUnitOfWork instantiateIfRequiredFor: c1 mapping: mapping).
]

{ #category : #tests }
GlorpUnitOfWorkTest >> testCheckIfInstantiationRequiredForRelationshipNoProxy [
	| c1 mapping |
	c1 := GlorpCustomer new.
	c1 accounts: #().
	session beginUnitOfWork.
	session register: c1.
	c1 accounts: nil.
	mapping := (session descriptorFor: GlorpCustomer) mappingForAttributeNamed: #accounts.
	self deny: (session privateGetCurrentUnitOfWork instantiateIfRequiredFor: c1 mapping: mapping).
]

{ #category : #tests }
GlorpUnitOfWorkTest >> testCheckIfInstantiationRequiredForRelationshipWithChange [
	"Note that we explicitly register the objects as being old (even though they aren't) so that we don't force instantation of the related objects, which is what we're trying to test."
	| c1 mapping proxy |
	c1 := GlorpCustomer new.
	proxy := Proxy new.
	proxy session: session.
	proxy query: (GlorpQueryStub new result: 'foo').
	c1 accounts: proxy.
	session beginUnitOfWork.
	session privateRegisterAsOld: c1.
	c1 accounts: #().
	mapping := (session descriptorFor: GlorpCustomer) mappingForAttributeNamed: #accounts.
	self assert: (session privateGetCurrentUnitOfWork instantiateIfRequiredFor: c1 mapping: mapping).
]

{ #category : #tests }
GlorpUnitOfWorkTest >> testCheckIfInstantiationRequiredForToManyRelationshipFromNew [
	"Note that we force the object to be registered as new, just to make absolutely sure it's being treated as a new object."
	| c1 proxy |
	c1 := GlorpCustomer new.
	proxy := Proxy new.
	proxy session: session.
	c1 accounts: proxy.
	session beginUnitOfWork.
	session privateRegisterAsNew: c1.
	self assert: (proxy isInstantiated).
]

{ #category : #tests }
GlorpUnitOfWorkTest >> testCommitOrderAtSessionLevel [

	| tables | 
	tables := session tablesInCommitOrder.
	tables first name = 'CUSTOMER'.
	self unfinished.
]

{ #category : #'tests-transaction wrappers' }
GlorpUnitOfWorkTest >> testInTransactionDoSuccessful [
	"This has to test that a transaction completed successfully, so unlike most other tests, we have to clean up the evidence afterwards"

	| result endResult |
	[session inTransactionDo: [
		session writeRow: session system exampleAddressRow].
	result := session read: GlorpAddress.
	self assert: result size = 1.
	self assert: result first id = 123]
		ensure: [session inTransactionDo: [session accessor executeSQLStringNoResult: 'DELETE FROM GR_ADDRESS']].
	endResult := session read: GlorpAddress.
	self assert: endResult size = 0.
]

{ #category : #'tests-transaction wrappers' }
GlorpUnitOfWorkTest >> testInTransactionDoUnsuccessful [

	| result initial|
	initial := session read: GlorpAddress.
	self assert: initial isEmpty.
	[session inTransactionDo: [
		session writeRow: session system exampleAddressRow.
		self error: 'no you don''t']] on: Dialect error do: [:ex | ex return: nil].
	result := session read: GlorpAddress.
	self assert: result size = 0.
]

{ #category : #tests }
GlorpUnitOfWorkTest >> testOriginalValueFor [
	| c1 mapping |
	c1 := GlorpCustomer new.
	c1 name: 'fred'.
	session beginUnitOfWork.
	session register: c1.
	c1 name: 'barney'.
	mapping := (session descriptorFor: GlorpCustomer) mappingForAttributeNamed: #name.
	self assert: (session privateGetCurrentUnitOfWork originalValueFor: c1 mapping: mapping) = 'fred'.
]

{ #category : #'tests-registration' }
GlorpUnitOfWorkTest >> testPostRegister [
	| c1 t1 t2 |
	c1 := GlorpCustomer example2.
	[session beginTransaction.
	session beginUnitOfWork.
	t1 := GlorpBankTransaction new.
	t2 := GlorpBankTransaction new.
	c1 addTransaction: t1.
	c1 addTransaction: t2.
	session register: c1.
	self assert: (session isRegistered: c1).
	self assert: (session isRegistered: t1).
	self assert: (session isRegistered: t2).
	session commitUnitOfWork]
		ensure: [session rollbackTransaction].
	"Need some assertions on what was written"
	self unfinished.
]

{ #category : #'tests-registration' }
GlorpUnitOfWorkTest >> testPreRegister [
	
	| c1 t1 t2 trans |
	c1 := GlorpCustomer example2.
	[session beginTransaction.
	session beginUnitOfWork.
	session register: c1.
	t1 := GlorpBankTransaction new.
	t2 := GlorpBankTransaction new.
	c1 addTransaction: t1.
	c1 addTransaction: t2.
	trans := session privateGetCurrentUnitOfWork privateGetTransaction.
	session commitUnitOfWork.
	self assert: (trans isRegistered: c1).
	self assert: (trans isRegistered: t1).
	self assert: (trans isRegistered: t2).]
		ensure: [session rollbackTransaction].
	"Need some assertions on what got written"
	self unfinished.
]

{ #category : #'tests-registration' }
GlorpUnitOfWorkTest >> testRegisterAll [
	| c1 c2 collection |
	c1 := GlorpCustomer new.
	c2 := GlorpCustomer new.
	session beginUnitOfWork.
	collection := Array with: c1 with: c2.
	session registerAll: collection.
	self assert: (session isRegistered: c1).
	self assert: (session isRegistered: c2).
	self deny: (session isRegistered: collection).
]

{ #category : #'tests-registration' }
GlorpUnitOfWorkTest >> testRegisterCollection [
	| c1 c2 collection |
	c1 := GlorpCustomer new.
	c2 := GlorpCustomer new.
	session beginUnitOfWork.
	collection := Array with: c1 with: c2.
	session register: collection.
	self assert: (session isRegistered: c1).
	self assert: (session isRegistered: collection).
]

{ #category : #'tests-registration' }
GlorpUnitOfWorkTest >> testRegisterEmbeddedInTargetDontRefetch [
	" This tests for a problem with embedded objects suddenly becoming nil. This can happen when an object is part of a to-many relation. If the relation is followed during the registering phase the query will wrongly replace the embedded object even though requiresPopulating is false. When the object itself is already registered the replaced embedded object won't be registered."

	| transactionId customer |
	
	[session beginTransaction.
	session inUnitOfWorkDo: 
			[customer := GlorpCustomer example1.
			customer id: 42.
			session register: customer].
	transactionId := customer transactions first id.
	customer := nil.
	session initializeCache.
	session inUnitOfWorkDo: 
			[| transaction amount |
			transaction := session readOneOf: GlorpBankTransaction
						where: [:each | each id = transactionId].
			amount := transaction amount.
			transaction owner transactions getValue.
			self assert: amount == transaction amount]] 
			ensure: [session rollbackTransaction]
]

{ #category : #'tests-registration' }
GlorpUnitOfWorkTest >> testRegisterExistingCollection [
	| c1 |
	c1 := GlorpCustomer new.
	session beginUnitOfWork.
	session register: c1.
	session register: c1 transactions.
	self assert: (session isRegistered: c1).
	self assert: (session isRegistered: c1 transactions).
	self deny: (session isNew: c1 transactions).
]

{ #category : #'tests-registration' }
GlorpUnitOfWorkTest >> testRegisterInstantiatedProxy [
	| p c |
	p := self exampleCustomerProxy.
	c := p getValue.
	session beginUnitOfWork.
	session register: p.
	self assert: (session isRegistered: p).
	self assert: (session isRegistered: c).
	self assert: (session privateGetCurrentUnitOfWork privateGetTransaction isRegistered: p).
	self assert: (session privateGetCurrentUnitOfWork privateGetTransaction isRegistered: c).
]

{ #category : #'tests-registration' }
GlorpUnitOfWorkTest >> testRegisterObjectWithCollectionProxyThenInstantiate [
	"Note that we explicitly register the objects as being old (even though they aren't) so that we don't force instantation of the related objects, which is what we're trying to test."
	| customer transactions |
	customer := self exampleCustomerWithTransactionsProxy.
	session beginUnitOfWork.
	session privateRegisterAsOld: customer.
	self deny: customer transactions isInstantiated.
	transactions := customer transactions getValue.
	self assert: customer transactions isInstantiated.
	session register: transactions.
	self assert: (session isRegistered: transactions first).
	self assert: (session isRegistered: customer).
	self assert: (session isRegistered: transactions).
	self assert: (session isRegistered: customer transactions).
]

{ #category : #'tests-registration' }
GlorpUnitOfWorkTest >> testRegisterObjectWithInstantiatedProxy [
	| transaction customer |
	transaction := self exampleTransactionWithCustomerProxy.
	customer := transaction owner getValue.
	session beginUnitOfWork.
	session register: transaction.
	self assert: (session isRegistered: transaction).
	self assert: (session isRegistered: customer).
	self assert: (session privateGetCurrentUnitOfWork privateGetTransaction 
				isRegistered: transaction).
	self assert: (session privateGetCurrentUnitOfWork privateGetTransaction 
				isRegistered: customer).
	self assert: transaction owner isInstantiated.
]

{ #category : #'tests-registration' }
GlorpUnitOfWorkTest >> testRegisterObjectWithNilCollection [
	| c1 |
	c1 := GlorpCustomer new.
	c1 transactions: nil.
	session beginUnitOfWork.
	session register: c1.
	self assert: (session isRegistered: c1).
]

{ #category : #'tests-registration' }
GlorpUnitOfWorkTest >> testRegisterObjectWithProxy [
	"Note that we explicitly register the objects as being old (even though they aren't) so that we don't force instantation of the related objects, which is what we're trying to test."
	| transaction |
	transaction := self exampleTransactionWithCustomerProxy.
	session beginUnitOfWork.
	session privateRegisterAsOld: transaction.
	self assert: (session isRegistered: transaction).
	self assert: (session privateGetCurrentUnitOfWork privateGetTransaction 
				isRegistered: transaction).
	self deny: transaction owner isInstantiated.
]

{ #category : #'tests-registration' }
GlorpUnitOfWorkTest >> testRegisterObjectWithProxyThenInstantiate [
	"Note that we explicitly register the objects as being old (even though they aren't) so that we don't force instantation of the related objects, which is what we're trying to test."
	| transaction customer |
	transaction := self exampleTransactionWithCustomerProxy.
	session beginUnitOfWork.
	session privateRegisterAsOld: transaction.
	self deny: transaction owner isInstantiated.
	customer := transaction owner getValue.
	session register: transaction.
	self assert: (session isRegistered: transaction).
	self assert: (session isRegistered: customer).
	self assert: (session privateGetCurrentUnitOfWork privateGetTransaction 
				isRegistered: transaction).
	self assert: (session privateGetCurrentUnitOfWork privateGetTransaction 
				isRegistered: customer).
	self assert: transaction owner isInstantiated
]

{ #category : #'tests-registration' }
GlorpUnitOfWorkTest >> testRegisterObjectWithProxyThenInstantiateAndReregister [
	| transaction customer |
	transaction := self exampleTransactionWithCustomerProxy.
	session beginUnitOfWork.
	session register: transaction.
	customer := transaction owner getValue.
	session register: transaction.
	self assert: (session isRegistered: transaction).
	self assert: (session isRegistered: customer).
	self assert: (session privateGetCurrentUnitOfWork privateGetTransaction 
				isRegistered: transaction).
	self assert: (session privateGetCurrentUnitOfWork privateGetTransaction 
				isRegistered: customer).
	self assert: transaction owner isInstantiated
]

{ #category : #'tests-registration' }
GlorpUnitOfWorkTest >> testRegisterProxy [
	| p |
	p := self exampleCustomerProxy.
	session beginUnitOfWork.
	session register: p.
	self deny: (session isRegistered: p).
	self deny: (session isRegistered: p query result).
	p getValue.
	self assert: (session isRegistered: p).
	self assert: (session isRegistered: p query result).
]

{ #category : #'tests-registration' }
GlorpUnitOfWorkTest >> testRegisterProxyThenInstantiateAndReregister [
	| p c |
	p := self exampleCustomerProxy.
	session beginUnitOfWork.
	session register: p.
	c := p getValue.
	session register: p.
	self assert: (session isRegistered: p).
	self assert: (session isRegistered: c).
	self assert: (session privateGetCurrentUnitOfWork privateGetTransaction 
				isRegistered: p).
	self assert: (session privateGetCurrentUnitOfWork privateGetTransaction 
				isRegistered: c)
]

{ #category : #'tests-forcing update' }
GlorpUnitOfWorkTest >> testRegisteringAndForcingUpdate [
	"Test that we can force the first customer to be rewritten, even if it hasn't been modified by using the #forceSaveOf: call."

	| customer triedToWrite row table map otherCustomer |
	session beginTransaction.
	customer := GlorpCustomer example1 id: 7.
	otherCustomer := GlorpCustomer example2 id: 8.
	session modify: (Array with: customer with: otherCustomer) in: [].
	session accessor denyWrites.
	session modify: customer in: [].
	session beginUnitOfWork.
	session register: otherCustomer.
	session save: customer.
	[session commitUnitOfWork] on: GlorpIllegalCommand do: [:ex |
		triedToWrite := true.
		table := session system tableNamed: 'GR_CUSTOMER'.
		map := session privateGetCurrentUnitOfWork privateGetRowMap subMapForTable: table.
		row := map at: map keys asArray first.
		self assert: (row at: row fields first) = 7.
		self assert: (row at: row fields last) = 'Fred Flintstone'.
		self assert: map size = 1.
	].
	self assert: triedToWrite.
	session rollbackTransaction.
]

{ #category : #'tests-forcing update' }
GlorpUnitOfWorkTest >> testRegisteringAndForcingUpdateToDatabase [
	"Test going round trip to the database with forceSaveOf:. This doesn't assert much, but is mostly to make sure we aren't doing an insert instead of an update."

	| customer otherCustomer |
	session beginTransaction.
	customer := GlorpCustomer example1 id: 7.
	otherCustomer := GlorpCustomer example2 id: 8.
	session modify: (Array with: customer with: otherCustomer) in: [].
	session inUnitOfWorkDo: [
		session register: otherCustomer.
		session save: customer].
	session rollbackTransaction.
]

{ #category : #tests }
GlorpUnitOfWorkTest >> testRollbackOneToManyAfterAdd [
	| customer t1 t2 transList amount |
	customer := GlorpCustomer example1.
	t1 := customer transactions first.
	t2 := customer transactions last.
	transList := customer transactions.
	amount := t1 amount.
	session beginUnitOfWork.
	session register: customer.
	20 timesRepeat: [customer addTransaction: (GlorpBankTransaction new)].
	customer transactions first amount: 65543.
	session rollbackUnitOfWork.
	self assert: customer transactions == transList.
	self assert: customer transactions size = 2.
	self assert: customer transactions first == t1.
	self assert: customer transactions last == t2.
	self assert: t1 amount == amount.
]

{ #category : #tests }
GlorpUnitOfWorkTest >> testRollbackOneToManyAfterReplace [
	| customer t1 t2 transList |
	customer := GlorpCustomer example1.
	t1 := customer transactions first.
	t2 := customer transactions last.
	transList := customer transactions.
	session beginUnitOfWork.
	session register: customer.
	customer transactions: OrderedCollection new.
	session rollbackUnitOfWork.
	self assert: customer transactions == transList.
	self assert: customer transactions size = 2.
	self assert: customer transactions first == t1.
	self assert: customer transactions last == t2.
]

{ #category : #tests }
GlorpUnitOfWorkTest >> testRollbackOneToManyProxy [
	| customer t1 t2 transList |
	customer := GlorpCustomer example1.
	t1 := customer transactions first.
	t2 := customer transactions last.
	transList := customer transactions.
	session beginUnitOfWork.
	session register: customer.
	customer transactions: OrderedCollection new.
	session rollbackUnitOfWork.
	self assert: customer transactions == transList.
	self assert: customer transactions size = 2.
	self assert: customer transactions first == t1.
	self assert: customer transactions last == t2.
]

{ #category : #tests }
GlorpUnitOfWorkTest >> testRollbackOneToOne [
	| transaction customer |
	transaction := GlorpBankTransaction new.
	customer := GlorpCustomer new.
	transaction owner: customer.
	session beginUnitOfWork.
	session register: transaction.
	transaction owner: GlorpCustomer new.
	session rollbackUnitOfWork.
	self assert: transaction owner == customer.
]

{ #category : #tests }
GlorpUnitOfWorkTest >> testRollbackOneToOneWithProxy [
	| transaction customerProxy |
	transaction := self exampleTransactionWithCustomerProxy.
	customerProxy := transaction owner.
	session beginUnitOfWork.
	session register: transaction.
	transaction owner: GlorpCustomer new.
	session rollbackUnitOfWork.
	self assert: transaction owner == customerProxy
]

{ #category : #'tests-transaction wrappers' }
GlorpUnitOfWorkTest >> testTransactSuccessful [
	"This has to test that a transaction completed successfully, so unlike most other tests, we have to clean up the evidence afterwards"

	| result |
	[session transact: [
		session register: (GlorpReservation new id: 345)].
	result := session read: GlorpReservation.
	self assert: result size = 1.
	self assert: result first id = 345]
		ensure: [session transact: [session accessor executeSQLStringNoResult: 'DELETE FROM RESERVATION']].
]

{ #category : #'tests-transaction wrappers' }
GlorpUnitOfWorkTest >> testTransactUnsuccessful [

	| result |
	[session transact: [
		session register: (GlorpReservation new id: 345).
		self error: 'didn''t work']] on: Dialect error do: [:ex | ex return: nil].
	result := session read: GlorpReservation.
	self assert: result size = 0.
]

{ #category : #tests }
GlorpUnitOfWorkTest >> testWriteObjectWithNilCollection [
	| c1 query customer |
	c1 := GlorpCustomer new.
	c1 transactions: nil.
	c1 id: 9999.
	[session beginTransaction.
	session beginUnitOfWork.
	session register: c1.
	session commitUnitOfWork.
	query := Query readOneOf: GlorpCustomer where: [:each | each id = 9999].
	query shouldRefresh: true.
	customer := session execute: query.
	self assert: customer transactions notNil.
	self assert: customer transactions isEmpty.
	]
		ensure: [session rollbackTransaction].
]

{ #category : #'tests-transaction wrappers' }
GlorpUnitOfWorkTest >> testinUnitOfWorkSuccessful [

	| result |
	[session beginTransaction.
	session inUnitOfWorkDo: [
		session register: (GlorpReservation new id: 345)].
	result := session read: GlorpReservation.
	self assert: result size = 1.
	self assert: result first id = 345]
		ensure: [session rollbackTransaction].
]

{ #category : #'tests-transaction wrappers' }
GlorpUnitOfWorkTest >> testinUnitOfWorkUnsuccessful [

	| result |
	[session beginTransaction.
	[session inUnitOfWorkDo: [
		session register: (GlorpReservation new id: 345).
		self error: 'aaaagh']] on: Dialect error do: [:ex | ex return: nil].
	result := session read: GlorpReservation.
	self assert: result size = 0]
		ensure: [session rollbackTransaction].
]
