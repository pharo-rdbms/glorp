Class {
	#name : #GlorpTimedStrongCacheTest,
	#superclass : #GlorpCacheTest,
	#category : 'Glorp-Tests-Tests'
}

{ #category : #tests }
GlorpTimedStrongCacheTest >> setUp [
	super setUp.
	self setUpExpiryWithRealDelay.
]

{ #category : #tests }
GlorpTimedStrongCacheTest >> setUpExpiryWithRealDelay [
	(cache session descriptorFor: GlorpCustomer) cachePolicy: (TimedStrongCachePolicy new timeout: 1).
	(cache session descriptorFor: GlorpBankTransaction) cachePolicy: (TimedStrongCachePolicy new timeout: 1).
]

{ #category : #tests }
GlorpTimedStrongCacheTest >> setUpExpiryWithZeroDelay [
	(cache session descriptorFor: GlorpCustomer) cachePolicy: (TimedStrongCachePolicy new timeout: 0).
	(cache session descriptorFor: GlorpBankTransaction) cachePolicy: (TimedStrongCachePolicy new timeout: 0).
]

{ #category : #tests }
GlorpTimedStrongCacheTest >> setUpForExpiryActionOf: aSymbol [
	(cache session descriptorFor: GlorpCustomer) cachePolicy expiryAction: aSymbol.
	(cache session descriptorFor: GlorpBankTransaction) cachePolicy expiryAction: aSymbol.
]

{ #category : #support }
GlorpTimedStrongCacheTest >> setUpForNotify [
	self setUpForExpiryActionOf: #notify.
]

{ #category : #tests }
GlorpTimedStrongCacheTest >> setUpForNotifyAndRemove [
	self setUpForExpiryActionOf: #notifyAndRemove.
]

{ #category : #tests }
GlorpTimedStrongCacheTest >> setUpForRefresh [
	self setUpForExpiryActionOf: #refresh.
]

{ #category : #tests }
GlorpTimedStrongCacheTest >> testExpiryReturningNilWithRealDelay [
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
GlorpTimedStrongCacheTest >> testNotExpiredAfterRefresh [
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
GlorpTimedStrongCacheTest >> testNotify [
	| customer |
	self setUpExpiryWithZeroDelay.
	self setUpForNotify.
	customer := GlorpCustomer example1.
	cache at: 3 insert: customer.
	self deny: (cache lookupClass: GlorpCustomer key: 3 ifAbsent: [nil]) == nil.
	self assert: customer seenExpiry.
]

{ #category : #tests }
GlorpTimedStrongCacheTest >> testNotifyAndRemove [
	| customer |
	self setUpExpiryWithZeroDelay.
	self setUpForNotifyAndRemove.
	customer := GlorpCustomer example1.
	cache at: 3 insert: customer.
	self assert: (cache lookupClass: GlorpCustomer key: 3 ifAbsent: [nil]) == nil.
	self assert: customer seenExpiry = true.
]

{ #category : #tests }
GlorpTimedStrongCacheTest >> testRegisteredObjectsDoNotExpire [
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
