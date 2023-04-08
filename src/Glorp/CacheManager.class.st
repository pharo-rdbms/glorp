"
This is the entire cache for a session, consisting of multiple sub-caches, one per class.

Instance Variables:
	session	<Session>	The containing session.
	subCaches	<Dictionary from: Class to: Cache>	The per-class caches.



"
Class {
	#name : #CacheManager,
	#superclass : #Object,
	#instVars : [
		'subCaches',
		'session'
	],
	#category : #'Glorp-Core'
}

{ #category : #'*Glorp' }
CacheManager class >> forSession: aSession [ 
	^self new session: aSession.
]

{ #category : #'*Glorp' }
CacheManager class >> new [

	^super new initialize.
]

{ #category : #adding }
CacheManager >> at: aKey insert: anObject [

	| subCache |
	subCache := self cacheForClass: anObject class.
	subCache at: aKey ifAbsentPut: [anObject].
]

{ #category : #'private/caching' }
CacheManager >> cacheFor: anObject [
	"Get the cache for a particular object. Since this could conceivably be passed a proxy, check for that. The cache for an uninstantiated proxy is kind of ambiguous, treat it as nil.  This could also be a class"

	| nonMetaClass |
	nonMetaClass := anObject isBehavior ifTrue: [anObject] ifFalse: [anObject class].
	^nonMetaClass == Proxy
		ifTrue: [anObject isInstantiated ifTrue: [self cacheFor: anObject getValue] ifFalse: [nil]]
		ifFalse: [self cacheForClass: nonMetaClass].
]

{ #category : #'private/caching' }
CacheManager >> cacheForClass: aClass [
	| resolver cacheClass |

	resolver := (self session descriptorFor: aClass) typeResolver.
	cacheClass := resolver usesInheritance
		ifTrue: [ resolver rootClass ]
		ifFalse: [ aClass ].
	^ subCaches
		at: cacheClass
		ifAbsentPut: [ self makeCacheFor: cacheClass ]
]

{ #category : #querying }
CacheManager >> containsObject: anObject key: aKey [

	| cache |
	cache := self cacheForClass: anObject class.
	^cache includesKey: aKey as: anObject.
]

{ #category : #querying }
CacheManager >> containsObjectForClass: aClass key: aKey [

	| cache |
	cache := self cacheForClass: aClass.
	^cache includesKey: aKey.
]

{ #category : #querying }
CacheManager >> expireAll [
	subCaches do: [:each | each expireAll].
]

{ #category : #querying }
CacheManager >> expireClass: aClass key: aKey [

	^self expireClass: aClass key: aKey ifAbsent: [self error: 'Object not in cache'].
]

{ #category : #querying }
CacheManager >> expireClass: aClass key: aKey ifAbsent: failBlock [ 
	| cache |
	cache := self cacheForClass: aClass.
	(cache includesKey: aKey withClass: aClass) ifFalse: [^failBlock value].
	cache expireKey: aKey ifAbsent: [ failBlock value ].
]

{ #category : #'private/caching' }
CacheManager >> expiredInstanceOf: aClass key: aKey [

	^(self cacheForClass: aClass) expiredInstanceFor: aKey.
]

{ #category : #querying }
CacheManager >> hasExpired: anObject [
	| key cache |
	key := (session descriptorFor: anObject) primaryKeyFor: anObject.
	cache := self cacheFor: anObject.
	cache isNil ifTrue: [^false].  "We have an uninstantiated proxy."
	^cache hasExpired: key.
]

{ #category : #querying }
CacheManager >> hasExpired: aClass key: key [
	| cache |
	cache := self cacheFor: aClass.
	^cache hasExpired: key.
]

{ #category : #querying }
CacheManager >> hasObjectExpiredOfClass: aClass withKey: key [
	| cache |
	cache := self cacheForClass: aClass.
	^cache hasExpired: key.
]

{ #category : #'initialize/release' }
CacheManager >> initialize [

	subCaches := IdentityDictionary new: 100.
]

{ #category : #querying }
CacheManager >> lookupClass: aClass key: aKey [

	^self lookupClass: aClass key: aKey ifAbsent: [self error: 'cache miss'].
]

{ #category : #querying }
CacheManager >> lookupClass: aClass key: aKey ifAbsent: failBlock [

	| object |
	object := (self cacheForClass: aClass) at: aKey ifAbsent: failBlock.
	^(object isKindOf: aClass)
		ifTrue: [ object ]
		ifFalse: [ failBlock value ].
]

{ #category : #querying }
CacheManager >> lookupClass: aClass key: aKey ifAbsentPut: failBlock [

	^(self cacheForClass: aClass) at: aKey ifAbsentPut: failBlock.
]

{ #category : #'initialize/release' }
CacheManager >> makeCacheFor: aClass [ 
	| rootClass cache |
	rootClass := session isNil ifTrue: [aClass] ifFalse: [session lookupRootClassFor: aClass].
	cache := subCaches at: rootClass ifAbsentPut: [ Cache newFor: rootClass in: self ].
	subCaches at: aClass put: cache.
	^cache
]

{ #category : #querying }
CacheManager >> markAsCurrentOfClass: aClass key: key [
	| cache |
	aClass == Proxy ifTrue: [^self].
	cache := self cacheForClass: aClass.
	cache markAsCurrentAtKey: key.
]

{ #category : #accessing }
CacheManager >> numberOfElements [
	^subCaches inject: 0 into: [:sum :each |
		sum + each numberOfElements].
]

{ #category : #'initialize/release' }
CacheManager >> release [
	subCaches do: [:each | each release].
]

{ #category : #querying }
CacheManager >> removeClass: aClass key: aKey [

	^self removeClass: aClass key: aKey ifAbsent: [self error: 'Object not in cache'].
]

{ #category : #querying }
CacheManager >> removeClass: aClass key: aKey ifAbsent: failBlock [ 
	| cache |
	cache := self cacheForClass: aClass.
	(cache includesKey: aKey withClass: aClass) ifFalse: [^failBlock value].
	cache removeKey: aKey ifAbsent: [ failBlock value ].
]

{ #category : #accessing }
CacheManager >> session [

	^session.
]

{ #category : #accessing }
CacheManager >> session: aSession [ 
	session := aSession.
]

{ #category : #accessing }
CacheManager >> system [

	^self session system.
]
