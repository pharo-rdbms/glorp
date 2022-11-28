"
This is a proxy which only holds onto its value for a fixed amount of time, and then uninstantiates. This is useful in highly-connected object graphs, where we might like to get rid of parts of a large tree that we are no longer using, but where simple weak references won't give enough information. For one to one relationships, we can cut the proxy relation, the object will remain in cache if it is registered or being otherwised referenced, and if we ask for it again, we won't have to go to the database because it will be found in cache. It's probably not such a good idea to use these kind of proxies for collections, where we will have to go to the database again if we need the value. See also TimedProxyReaper.

Instance Variables:
	association	<Association> The association in the TimedProxyReaper which holds onto our identifier plus a time after which we should expire.
	id	<Integer>	An ID, assigned to us by the reaper, so that it doesn't hold strong references to us.
	reaper	<TimedProxyReaper>	The reaper which controls this proxy.
	secondsToLive	<ArithmeticValue>	How much time, in seconds, we should wait after we were last touched before expiring.
	timeToDie	<Integer>	The millisecond clock value at which we expire. Is this a problem if there are dialects/versions for which the millisecond clock wraps around?


"
Class {
	#name : #TimedProxy,
	#superclass : #Proxy,
	#instVars : [
		'id',
		'reaper',
		'secondsToLive',
		'timeToDie',
		'association'
	],
	#category : 'Glorp-Queries'
}

{ #category : #accessing }
TimedProxy >> class [
	^TimedProxy
]

{ #category : #accessing }
TimedProxy >> doesNotUnderstand: aMessage [

	self glorpTouch.
	^super doesNotUnderstand: aMessage
]

{ #category : #accessing }
TimedProxy >> glorpAssociation [
	^association
]

{ #category : #accessing }
TimedProxy >> glorpAssociation: anAssociation [
	association := anAssociation
]

{ #category : #accessing }
TimedProxy >> glorpId [
	^id
]

{ #category : #accessing }
TimedProxy >> glorpId: uniqueInteger [
	id := uniqueInteger
]

{ #category : #accessing }
TimedProxy >> glorpReaper: aTimedProxyReaper [
	reaper := aTimedProxyReaper
]

{ #category : #accessing }
TimedProxy >> glorpSecondsToLive [
	"Answer the number of seconds the receiver should live after having been instantiated or sent a message."

	^secondsToLive
]

{ #category : #accessing }
TimedProxy >> glorpSecondsToLive: seconds [

	secondsToLive := seconds.
	self updateExpiryTime.
	reaper notNil ifTrue: [self glorpTouch]
]

{ #category : #accessing }
TimedProxy >> glorpTimeToDie [
	"Answer the time at which the receiver is scheduled to die."

	^timeToDie
]

{ #category : #accessing }
TimedProxy >> glorpTouch [
	self updateExpiryTime.
	reaper isNil ifFalse: [reaper touch: self].
]

{ #category : #accessing }
TimedProxy >> proxyInitialize [
	super proxyInitialize.
	secondsToLive := 30.
	self updateExpiryTime.
]

{ #category : #accessing }
TimedProxy >> uninstantiate [

	super uninstantiate.
	association := nil.
]

{ #category : #accessing }
TimedProxy >> updateExpiryTime [
	timeToDie := Time millisecondClockValue + (secondsToLive * 1000)
]
