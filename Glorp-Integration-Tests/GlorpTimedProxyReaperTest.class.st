Class {
	#name : #GlorpTimedProxyReaperTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'reaper'
	],
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #tests }
GlorpTimedProxyReaperTest >> README [

	"Unfortunately, these tests are timing sensitive. They may intermittently fail, when in fact they are working as advertised.
	Rerun failed tests individually. If a test consistently fails, then it likely indicates a bug."
]

{ #category : #support }
GlorpTimedProxyReaperTest >> setUp [
	reaper := TimedProxyReaper new.
	reaper delay: 0.5.
]

{ #category : #support }
GlorpTimedProxyReaperTest >> tearDown [

	reaper release.
	reaper := nil.
]

{ #category : #tests }
GlorpTimedProxyReaperTest >> testAddObjects [

	| proxies |
	proxies := OrderedCollection new.
	1 to: 10 do: [:index | 
		proxies add: (TimedProxy readOneOf: Object where: nil in: nil).
		proxies last glorpSecondsToLive: 1000.
		reaper add: proxies last].

	(Delay forSeconds: 1) wait.
	proxies do: [:proxy | self should: [reaper includes: proxy]].
]

{ #category : #tests }
GlorpTimedProxyReaperTest >> testExpireObjects [

	| proxies |
	proxies := OrderedCollection new.
	1 to: 10 do: [:index | 
		proxies add: (TimedProxy readOneOf: Object where: nil in: nil).
		proxies last glorpSecondsToLive: 1.
		reaper add: proxies last].

	(Delay forSeconds: 5) wait.
	proxies do: [:proxy | self shouldnt: [reaper includes: proxy]].
]

{ #category : #tests }
GlorpTimedProxyReaperTest >> testTouchAndExpireObjectsWhileOtherObjectsAreBeingReaped [

	| expiringProxy proxy |
	reaper delay: 0.25.
	expiringProxy := TimedProxy readOneOf: Object where: nil in: nil.
	expiringProxy glorpSecondsToLive: 1.
	proxy := TimedProxy readOneOf: Object where: nil in: nil.
	proxy glorpSecondsToLive: 2.

	reaper add: proxy; add: expiringProxy.
	self assert: (reaper includes: proxy).
	self assert: (reaper includes: expiringProxy).
	(Delay forSeconds: 1) wait.
	proxy glorpTouch.
	(Delay forSeconds: 1.5) wait.
	self assert: (reaper includes: proxy).
	self deny: (reaper includes: expiringProxy).
	(Delay forSeconds: 2) wait.
	self deny: (reaper includes: proxy).
]

{ #category : #tests }
GlorpTimedProxyReaperTest >> testTouchObjects [

	| proxy |
	reaper delay: 0.25.
	proxy := TimedProxy readOneOf: Object where: nil in: nil.
	proxy glorpSecondsToLive: 2.
	reaper add: proxy.
	(Delay forSeconds: 1) wait.
	proxy glorpTouch.
	(Delay forSeconds: 1.1) wait.
	self should: [reaper includes: proxy].
	(Delay forSeconds: 2) wait.
	self shouldnt: [reaper includes: proxy]
]
