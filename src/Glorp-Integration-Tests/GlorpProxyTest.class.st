Class {
	#name : #GlorpProxyTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'session',
		'proxy',
		'result'
	],
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #resources }
GlorpProxyTest class >> resources [

	^Array with: GlorpSessionResource.
]

{ #category : #running }
GlorpProxyTest >> setUp [

	| stub |
	super setUp.
	session := GlorpSessionResource current newSession.
	proxy := Proxy new.
	proxy session: session.
	stub := GlorpQueryStub readOneOf: GlorpAddress where: [:address | address id = 1].
	result:= GlorpAddress new.
	stub result: result.
	proxy query: stub.
	proxy parameters: #()
]

{ #category : #tests }
GlorpProxyTest >> testAdHocProxy [
	"Some dialects (e.g. VA) inline yourself so we must send yourSelf."

	| p |
	p := AdHocProxy readBlock: ['instantiated!'].
	self assert: p printString = '{uninstantiated AdHocProxy}'.
	self assert: p isInstantiated not.
	p yourSelf.
	self assert: p isInstantiated.
	self assert: p printString = '{''instantiated!''}'.
	p uninstantiate.
	self deny: p isInstantiated.
]

{ #category : #tests }
GlorpProxyTest >> testCreation [
	| otherProxy |
	self deny: proxy isInstantiated.
	otherProxy := Proxy new.
	self deny: otherProxy isInstantiated.
]

{ #category : #tests }
GlorpProxyTest >> testInstantiationFromStub [

	self assert: (proxy getValue notNil).
	self assert: proxy equals: result.
	self assert: proxy isInstantiated.
]

{ #category : #tests }
GlorpProxyTest >> testPrintingInstantiated [

	proxy getValue.
	self assert: proxy printString = ('{', proxy getValue printString, '}').
]

{ #category : #tests }
GlorpProxyTest >> testPrintingUninstantiated [

	self assert: proxy printString = '{uninstantiated GlorpAddress}'.
]

{ #category : #tests }
GlorpProxyTest >> testPrintingUninstantiatedCollection [
	proxy query readsOneObject: false.
	self assert: proxy printString = '{uninstantiated collection of GlorpAddress}'.
]

{ #category : #tests }
GlorpProxyTest >> testSpecies [ 

	self assert: proxy species equals: GlorpAddress 
]
