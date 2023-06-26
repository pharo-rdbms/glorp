Class {
	#name : #GlorpTimedExpiryCacheTest,
	#superclass : #GlorpCacheTest,
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #running }
GlorpTimedExpiryCacheTest >> setUp [

	super setUp.
	self setUpExpiryWithRealDelay
]

{ #category : #'private - running' }
GlorpTimedExpiryCacheTest >> setUpExpiryWithRealDelay [

	(cache session descriptorFor: GlorpCustomer) cachePolicy: (TimedExpiryCachePolicy new timeout: 1).
	(cache session descriptorFor: GlorpBankTransaction) cachePolicy: (TimedExpiryCachePolicy new timeout: 1)
]

{ #category : #'private - running' }
GlorpTimedExpiryCacheTest >> setUpExpiryWithZeroDelay [

	(cache session descriptorFor: GlorpCustomer) cachePolicy: (TimedExpiryCachePolicy new timeout: 0).
	(cache session descriptorFor: GlorpBankTransaction) cachePolicy: (TimedExpiryCachePolicy new timeout: 0)
]

{ #category : #'private - running' }
GlorpTimedExpiryCacheTest >> setUpForExpiryActionOf: aSymbol [

	(cache session descriptorFor: GlorpCustomer) cachePolicy expiryAction: aSymbol.
	(cache session descriptorFor: GlorpBankTransaction) cachePolicy expiryAction: aSymbol
]

{ #category : #'private - running' }
GlorpTimedExpiryCacheTest >> setUpForNotify [

	self setUpForExpiryActionOf: #notify
]

{ #category : #'private - running' }
GlorpTimedExpiryCacheTest >> setUpForNotifyAndRemove [

	self setUpForExpiryActionOf: #notifyAndRemove
]

{ #category : #'private - running' }
GlorpTimedExpiryCacheTest >> setUpForRefresh [

	self setUpForExpiryActionOf: #refresh
]

{ #category : #tests }
GlorpTimedExpiryCacheTest >> testExpiryReturningNilWithRealDelay [
	"test that objects expire with a non-zero delay time."
	| customer customer2 |
	customer := GlorpCustomer example1.
	cache at: 3 insert: customer.
	self deny: (cache lookupClass: GlorpCustomer key: 3 ifAbsent: [nil]) == nil.
	(Delay forSeconds: 2) wait.
	self assert: (cache lookupClass: GlorpCustomer key: 3 ifAbsent: [nil]) == nil.
	customer2 := GlorpCustomer new.
	cache at: 3 insert: customer2.
	self assert: (cache lookupClass: GlorpCustomer key: 3 ifAbsent: [nil]) == customer2.
]

{ #category : #tests }
GlorpTimedExpiryCacheTest >> testNotExpiredAfterRefresh [
	| customer |
	self setUpForRefresh.
	session accessor beginTransaction.
	[session accessor executeSQLStringNoResult: 'INSERT INTO GR_CUSTOMER VALUES (3,''Fred Flintstone'')'.
	customer := session execute: (Query readOneOf: GlorpCustomer where: [:each | each id = 3]).
	(Delay forSeconds: 2) wait.
	self assert: (cache hasExpired: customer).
	self assert: (cache lookupClass: GlorpCustomer key: 3 ifAbsent: [nil]) == customer.
	self deny: (cache hasExpired: customer)]
		ensure: [session accessor rollbackTransaction].
]

{ #category : #tests }
GlorpTimedExpiryCacheTest >> testNotify [
	| customer |
	self setUpExpiryWithZeroDelay.
	self setUpForNotify.
	customer := GlorpCustomer example1.
	cache at: 3 insert: customer.
	self deny: (cache lookupClass: GlorpCustomer key: 3 ifAbsent: [nil]) == nil.
	self assert: customer seenExpiry.
]

{ #category : #tests }
GlorpTimedExpiryCacheTest >> testNotifyAndRemove [
	| customer |
	self setUpExpiryWithZeroDelay.
	self setUpForNotifyAndRemove.
	customer := GlorpCustomer example1.
	cache at: 3 insert: customer.
	self assert: (cache lookupClass: GlorpCustomer key: 3 ifAbsent: [nil]) == nil.
	self assert: customer seenExpiry = true.
]

{ #category : #tests }
GlorpTimedExpiryCacheTest >> testRegisteredObjectsDoNotExpire [
	| customer |
	self setUpExpiryWithZeroDelay.
	self setUpForNotifyAndRemove.
	customer := GlorpCustomer example1.
	customer id: 3.
	cache at: 3 insert: customer.
	session beginUnitOfWork.
	session register: customer.
	self assert: (cache lookupClass: GlorpCustomer key: 3 ifAbsent: [nil]) == customer.
	self deny: customer seenExpiry.
]
