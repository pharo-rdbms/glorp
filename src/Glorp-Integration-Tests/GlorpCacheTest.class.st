Class {
	#name : #GlorpCacheTest,
	#superclass : #GlorpDatabaseBasedTest,
	#instVars : [
		'cache',
		'session'
	],
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #'as yet unclassified' }
GlorpCacheTest class >> resources [
	^Array with: GlorpSessionResource
]

{ #category : #support }
GlorpCacheTest >> setUp [
	super setUp.
	system cachePolicy: CachePolicy new.
	session := GlorpSessionResource current newSession.
	session system: system.
	cache := session privateGetCache.
]

{ #category : #support }
GlorpCacheTest >> tearDown [
	super tearDown.
	session reset.
	session := nil.
]

{ #category : #tests }
GlorpCacheTest >> testDuplicates [ 
	| c1 c2 |
	c1 := GlorpCustomer example1.
	c2 := GlorpCustomer example1.
	cache at: 3 insert: c1.
	cache at: 3 insert: c2.
	self assert: (cache lookupClass: GlorpCustomer key: 3) = c1.
]

{ #category : #tests }
GlorpCacheTest >> testDuplicatesDifferentClasses [

	| cust trans |
	cust := GlorpCustomer example1.
	trans := GlorpBankTransaction example1.
	cache at: 3 insert: cust.
	cache at: 3 insert: trans.
	self assert: (cache lookupClass: GlorpCustomer key: 3) = cust.
	self assert: (cache lookupClass: GlorpBankTransaction key: 3) = trans.
]

{ #category : #tests }
GlorpCacheTest >> testInsert [
	| customer |
	customer := GlorpCustomer example1.
	cache at: 3 insert: customer.
	self assert: (cache lookupClass: GlorpCustomer key: 3) == customer
]

{ #category : #tests }
GlorpCacheTest >> testManualExpireAll [
	| customer customer2 readBackCustomer |
	system cachePolicy: TimedExpiryCachePolicy new.
	customer := GlorpCustomer example1.
	cache at: 3 insert: customer.
	self deny: (cache lookupClass: GlorpCustomer key: 3 ifAbsent: [nil]) == nil.
	cache expireAll.
	readBackCustomer := session readOneOf: GlorpCustomer where: [:each | each id = 3].
	self assert: readBackCustomer isNil.
	self assert: (cache lookupClass: GlorpCustomer key: 3 ifAbsent: [nil]) == nil.
	customer2 := GlorpCustomer new.
	cache at: 3 insert: customer2.
	self assert: (cache lookupClass: GlorpCustomer key: 3 ifAbsent: [nil]) == customer2.
]

{ #category : #tests }
GlorpCacheTest >> testManualExpiry [
	| customer customer2 readBackCustomer |
	system cachePolicy: TimedExpiryCachePolicy new.
	customer := GlorpCustomer example1.
	cache at: 3 insert: customer.
	self deny: (cache lookupClass: GlorpCustomer key: 3 ifAbsent: [nil]) == nil.
	cache expireClass: GlorpCustomer key: 3 ifAbsent: [self error: 'wrong'].
	readBackCustomer := session readOneOf: GlorpCustomer where: [:each | each id = 3].
	self assert: readBackCustomer isNil.
	self assert: (cache lookupClass: GlorpCustomer key: 3 ifAbsent: [nil]) == nil.
	customer2 := GlorpCustomer new.
	cache at: 3 insert: customer2.
	self assert: (cache lookupClass: GlorpCustomer key: 3 ifAbsent: [nil]) == customer2.
]

{ #category : #tests }
GlorpCacheTest >> testRemove [
	| customer |
	customer := GlorpCustomer example1.
	cache at: 3 insert: customer.
	self assert: (cache lookupClass: GlorpCustomer key: 3) == customer.
	cache removeClass: GlorpCustomer key: 3 ifAbsent: [ self signalFailure: 'Item was not in cache.' ].
	self assert: (cache lookupClass: GlorpCustomer key: 3 ifAbsent: []) == nil.
]
