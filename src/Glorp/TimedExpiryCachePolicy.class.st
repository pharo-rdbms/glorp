"
This implements a cache that notes that an object is stale after some amount of time since it has been read.

Instance Variables:
	timeout	<Integer>	The time in seconds until we note an object as needing refreshing.



"
Class {
	#name : 'TimedExpiryCachePolicy',
	#superclass : 'CachePolicy',
	#instVars : [
		'timeout'
	],
	#category : 'Glorp-Core',
	#package : 'Glorp',
	#tag : 'Core'
}

{ #category : 'wrap/unwrap' }
TimedExpiryCachePolicy >> cacheEntryFor: anObject [

	^ Array with: self totalSeconds with: anObject
]

{ #category : 'wrap/unwrap' }
TimedExpiryCachePolicy >> contentsOf: aCacheEntry [

	^ aCacheEntry at: 2
]

{ #category : 'expiry' }
TimedExpiryCachePolicy >> expire: aCacheEntry [

	^ aCacheEntry at: 1 put: 0
]

{ #category : 'wrap/unwrap' }
TimedExpiryCachePolicy >> hasExpired: aCacheEntry [

	^ (self totalSeconds - (aCacheEntry at: 1)) >= timeout
]

{ #category : 'initialization' }
TimedExpiryCachePolicy >> initialize [

	super initialize.
	timeout := 300
]

{ #category : 'wrap/unwrap' }
TimedExpiryCachePolicy >> markEntryAsCurrent: aCacheEntry in: aCache [

	aCacheEntry at: 1 put: self totalSeconds
]

{ #category : 'accessing' }
TimedExpiryCachePolicy >> timeout [

	^ timeout
]

{ #category : 'accessing' }
TimedExpiryCachePolicy >> timeout: seconds [

	timeout := seconds
]

{ #category : 'accessing' }
TimedExpiryCachePolicy >> timeoutSeconds [

	^ timeout
]

{ #category : 'accessing' }
TimedExpiryCachePolicy >> timeoutSeconds: anInteger [

	timeout := anInteger
]

{ #category : 'utilities' }
TimedExpiryCachePolicy >> totalSeconds [

	^ Dialect totalSeconds
]
