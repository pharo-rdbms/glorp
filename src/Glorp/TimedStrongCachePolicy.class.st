"
This implements a cache that notes that an object is stale after some amount of time since it has been read.

Instance Variables:
	timeout	<Integer>	The time in seconds until we note an object as needing refreshing.



"
Class {
	#name : 'TimedStrongCachePolicy',
	#superclass : 'CachePolicy',
	#instVars : [
		'timeout'
	],
	#category : 'Glorp-Core',
	#package : 'Glorp',
	#tag : 'Core'
}

{ #category : 'wrap/unwrap' }
TimedStrongCachePolicy >> cacheEntryFor: anObject [

	^ Array with: self totalSeconds with: anObject
]

{ #category : 'wrap/unwrap' }
TimedStrongCachePolicy >> contentsOf: aCacheEntry [

	^ aCacheEntry at: 2
]

{ #category : 'expiry' }
TimedStrongCachePolicy >> expire: aCacheEntry [

	^ aCacheEntry at: 1 put: 0
]

{ #category : 'wrap/unwrap' }
TimedStrongCachePolicy >> hasExpired: aCacheEntry [

	^ (self totalSeconds - (aCacheEntry at: 1)) >= timeout
]

{ #category : 'initialization' }
TimedStrongCachePolicy >> initialize [

	super initialize.
	timeout := 300
]

{ #category : 'wrap/unwrap' }
TimedStrongCachePolicy >> markEntryAsCurrent: aCacheEntry in: aCache [

	aCacheEntry at: 1 put: self totalSeconds
]

{ #category : 'accessing' }
TimedStrongCachePolicy >> timeout [

	^ timeout
]

{ #category : 'accessing' }
TimedStrongCachePolicy >> timeout: seconds [

	timeout := seconds
]

{ #category : 'accessing' }
TimedStrongCachePolicy >> timeoutSeconds [

	^ timeout
]

{ #category : 'accessing' }
TimedStrongCachePolicy >> timeoutSeconds: anInteger [

	timeout := anInteger
]

{ #category : 'utilities' }
TimedStrongCachePolicy >> totalSeconds [

	^ Dialect totalSeconds
]
