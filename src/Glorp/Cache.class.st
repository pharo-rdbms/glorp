"
This is the per-class cache of instances read from the database.

Instance Variables:
	items	<Dictionary from: Object to: Object>	The cached items, keyed by their primary key values
	policy	<CachePolicy>	The settings for this cache.



"
Class {
	#name : #Cache,
	#superclass : #Object,
	#instVars : [
		'items',
		'policy',
		'mainCache',
		'extraReferences'
	],
	#category : #'Glorp-Core'
}

{ #category : #'instance creation' }
Cache class >> new [

	^ super new initialize
]

{ #category : #'instance creation' }
Cache class >> newFor: aClass in: aCacheManager [

	| newCache descriptor |
	descriptor := aCacheManager session isNil ifFalse: [
		              aCacheManager system descriptorFor: aClass ].
	newCache := Cache new.
	newCache mainCache: aCacheManager.
	descriptor isNil
		ifTrue: [ newCache cachePolicy: CachePolicy default ]
		ifFalse: [ newCache cachePolicy: descriptor cachePolicy ].
	^ newCache
]

{ #category : #lookup }
Cache >> at: key ifAbsent: aBlock [

	| item value |
	item := self basicAt: key ifAbsent: [ ^ aBlock value ].
	value := policy contentsOf: item.
	(self hasItemExpired: item) ifTrue: [
		policy takeExpiryActionForKey: key withValue: value in: self.
		(items includesKey: key) ifFalse: [ ^ aBlock value ] ].
	^ value
]

{ #category : #lookup }
Cache >> at: key ifAbsentPut: aBlock [ 
	| item |
	item := self at: key ifAbsent: [nil].
	^item isNil 
		ifTrue: [ | newItem|
			newItem := policy cacheEntryFor: aBlock value.
			self markEntryAsCurrent: newItem.
			items at: key put: newItem]
		ifFalse: [self markEntryAsCurrent: item. item].
]

{ #category : #private }
Cache >> basicAt: anObject ifAbsent: aBlock [

	^ items at: anObject ifAbsent: aBlock
]

{ #category : #accessing }
Cache >> cachePolicy [

	^ policy
]

{ #category : #accessing }
Cache >> cachePolicy: aCachePolicy [

	policy := aCachePolicy.
	self initializeCache
]

{ #category : #private }
Cache >> do: aBlock [

	items do: aBlock
]

{ #category : #lookup }
Cache >> expireAll [

	items do: [ :each | policy expire: each ]
]

{ #category : #lookup }
Cache >> expireKey: key ifAbsent: aBlock [

	| item |
	item := self basicAt: key ifAbsent: [ ^ aBlock value ].
	policy expire: item
]

{ #category : #private }
Cache >> expiredInstanceFor: key [
	"Return the expired instance. Used for refreshing so that we don't recursively try and refresh when we get the instance to be refreshed"

	| item value |
	item := self
		        basicAt: key
		        ifAbsent: [ self error: 'No expired instance found' ].
	value := policy contentsOf: item.
	(self hasItemExpired: item) ifFalse: [
		self error: 'No expired instance found' ].
	^ value
]

{ #category : #lookup }
Cache >> hasExpired: key [

	| item |
	item := self basicAt: key ifAbsent: [ ^ false ].
	^ self hasItemExpired: item
]

{ #category : #lookup }
Cache >> hasItemExpired: anItem [

	^ (policy hasExpired: anItem) and: [
		  (mainCache session isRegistered: (policy contentsOf: anItem)) not ]
]

{ #category : #lookup }
Cache >> includesKey: key [
	"Return true if we include the object. Don't listen to any expiry policy"

	self basicAt: key ifAbsent: [ ^ false ].
	^ true
]

{ #category : #lookup }
Cache >> includesKey: key as: anObject [
	"Return true if we include the object, and it matches the given object. If we include a different object with the same key, raise an exception. Don't listen to any expiry policy"

	| item value |
	item := self basicAt: key ifAbsent: [ ^ false ].
	value := policy contentsOf: item.
	value == anObject ifFalse: [
		(DuplicatePrimaryKeyException new: anObject existing: value) signal ].
	^ true
]

{ #category : #lookup }
Cache >> includesKey: key withClass: aClass [
	"Return true if we include the object, and it matches our class. Don't listen to any expiry policy"

	| item value |
	item := self basicAt: key ifAbsent: [ ^ false ].
	value := policy contentsOf: item.
	^ value isKindOf: aClass
]

{ #category : #initialization }
Cache >> initialize [

	
]

{ #category : #initialization }
Cache >> initializeCache [

	items := policy newItemsIn: self.
	extraReferences := policy collectionForExtraReferences
]

{ #category : #accessing }
Cache >> mainCache [

	^ mainCache
]

{ #category : #accessing }
Cache >> mainCache: aCacheManager [

	mainCache := aCacheManager
]

{ #category : #private }
Cache >> markAsCurrentAtKey: key [

	| item |
	item := self basicAt: key ifAbsent: [ ^ false ].
	^ policy markEntryAsCurrent: item in: self
]

{ #category : #private }
Cache >> markEntryAsCurrent: anItem [
	"The policy has told us to mark an item as current. This is only really useful for weak policies, which tell us to keep an additional pointer to the object in a (presumably) fixed-size collection"

	extraReferences isNil ifFalse: [ extraReferences add: anItem ]
]

{ #category : #finalization }
Cache >> mournKeyOf: anEphemeron [

	policy
		takeExpiryActionForKey: anEphemeron key
		withValue: anEphemeron value
		in: self
]

{ #category : #accessing }
Cache >> numberOfElements [

	^ items size
]

{ #category : #dependencies }
Cache >> release [

	policy release: self.
	extraReferences := nil
]

{ #category : #lookup }
Cache >> removeKey: key ifAbsent: aBlock [

	^ items removeKey: key ifAbsent: aBlock
]

{ #category : #accessing }
Cache >> session [

	^ mainCache session
]

{ #category : #accessing }
Cache >> willRemoveItems [

	^ policy willRemoveItems
]
