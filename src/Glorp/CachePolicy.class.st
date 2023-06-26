"
A CachePolicy implements the different possible policies we might use for caching. The superclass implements the trivial policy of keeping all objects forever.

The policy also controls what we store in the cache. In general, it's assumed to be a cache entry of some sort, and the policy is responsible for wrapping and unwrapping objects going to and from the cache. The default policy is that the objects themselves are the cache entry (saving one object per cached object in overhead).

Instance Variables
	size	<Number>	The minimum cache size we want to use.
	expiryAction <Symbol> What to do when an object has expired. Currently hard-coded as one of #remove, #notify, #refresh, #notifyAndRemove.

"
Class {
	#name : #CachePolicy,
	#superclass : #Object,
	#instVars : [
		'expiryAction',
		'numberOfElements'
	],
	#category : #'Glorp-Core'
}

{ #category : #'*Glorp' }
CachePolicy class >> default [
	"Use of the WeakVWCache is tied in with Ephemera which we do not expect to get working in VW3."

	^ self new
]

{ #category : #'wrap/unwrap' }
CachePolicy >> cacheEntryFor: anObject [

	^ anObject
]

{ #category : #initialization }
CachePolicy >> collectionForExtraReferences [

	^ nil
]

{ #category : #'wrap/unwrap' }
CachePolicy >> contentsOf: aCacheEntry [

	^ aCacheEntry
]

{ #category : #accessing }
CachePolicy >> dictionaryClass [

	^ Dictionary
]

{ #category : #expiry }
CachePolicy >> expire: anItem [
	"Force anItem to be expired. This may be ignored if the policy doesn't respect this, and is ignored by default"
]

{ #category : #accessing }
CachePolicy >> expiryAction [

	^ expiryAction
]

{ #category : #accessing }
CachePolicy >> expiryAction: aSymbol [
	"See class comment for possible values"

	expiryAction := aSymbol
]

{ #category : #'wrap/unwrap' }
CachePolicy >> hasExpired: aCacheEntry [

	^ false
]

{ #category : #initialization }
CachePolicy >> initialize [

	numberOfElements := 100.
	expiryAction := #remove
]

{ #category : #'wrap/unwrap' }
CachePolicy >> markEntryAsCurrent: aCacheEntry in: aCache [

	^ self
]

{ #category : #initialization }
CachePolicy >> newItemsIn: aCache [

	^ self dictionaryClass new: 20
]

{ #category : #expiry }
CachePolicy >> notifyOfExpiry: anObject in: aCache [

	anObject glorpNoticeOfExpiryIn: aCache session
]

{ #category : #accessing }
CachePolicy >> numberOfElements [

	^ numberOfElements
]

{ #category : #accessing }
CachePolicy >> numberOfElements: anInteger [

	numberOfElements := anInteger
]

{ #category : #expiry }
CachePolicy >> release: aCache [

	(expiryAction == #notify or: [ expiryAction == #notifyAndRemove ])
		ifTrue: [
			aCache do: [ :each |
				(self contentsOf: each) glorpNoticeOfExpiryIn: aCache session ] ]
]

{ #category : #expiry }
CachePolicy >> takeExpiryActionForKey: key withValue: anObject in: aCache [

	expiryAction == #refresh ifTrue: [ aCache session refresh: anObject ].
	(#( #notify #notifyAndRemove ) includes: expiryAction) ifTrue: [
		self notifyOfExpiry: anObject in: aCache ].
	(#( #remove #notifyAndRemove ) includes: expiryAction) ifTrue: [
		aCache removeKey: key ifAbsent: [  ] ]
]

{ #category : #expiry }
CachePolicy >> willRemoveItems [

	^ #(notifyAndRemove remove) includes: expiryAction
]
