Class {
	#name : #GlorpProxyEqualityTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'session',
		'proxy',
		'proxy2',
		'stub2',
		'stub'
	],
	#category : 'Glorp-Tests-Models'
}

{ #category : #'as yet unclassified' }
GlorpProxyEqualityTest class >> resources [
	^Array with: GlorpSessionResource
]

{ #category : #'initialize-release' }
GlorpProxyEqualityTest >> setUp [ 

	super setUp. 
	session := GlorpSessionResource current newSession.
	proxy := Proxy new.
	proxy session: session.
	stub := GlorpQueryStub readOneOf: GlorpAddress where: [:address | address id = 1].
	stub result: 'abc'.
	proxy query: stub.
	proxy parameters: #().
	proxy2 := Proxy new.
	proxy2 session: session.
	stub2 := GlorpQueryStub readOneOf: GlorpAddress where: [:address | address id = 1].
	stub2 result: 'abc'.
	proxy2 query: stub2.
	proxy2 parameters: #().
]

{ #category : #'initialize-release' }
GlorpProxyEqualityTest >> setUp2 [
	proxy query result: 'def'
]

{ #category : #'initialize-release' }
GlorpProxyEqualityTest >> testEquality [
	self assert: proxy = proxy2.
]

{ #category : #'initialize-release' }
GlorpProxyEqualityTest >> testEquality2 [
	self assert: proxy2 = proxy.
]

{ #category : #'initialize-release' }
GlorpProxyEqualityTest >> testEqualityFailing [
	self setUp2.
	self deny: proxy = proxy2.
]

{ #category : #'initialize-release' }
GlorpProxyEqualityTest >> testEqualityFailing2 [
	self setUp2.
	self deny: proxy2 = proxy.
]

{ #category : #'initialize-release' }
GlorpProxyEqualityTest >> testInequality [
	self setUp2.
	self deny: proxy = proxy2.
]

{ #category : #'initialize-release' }
GlorpProxyEqualityTest >> testInequality2 [
	self setUp2.
	self deny: proxy2 = proxy.
]

{ #category : #'initialize-release' }
GlorpProxyEqualityTest >> testInequalityFailing [
	self deny: proxy ~= proxy2.
]

{ #category : #'initialize-release' }
GlorpProxyEqualityTest >> testInequalityFailing2 [
	self deny: proxy2 ~= proxy.
]
