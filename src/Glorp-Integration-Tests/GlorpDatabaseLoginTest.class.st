Class {
	#name : #GlorpDatabaseLoginTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'login',
		'accessor'
	],
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #'as yet unclassified' }
GlorpDatabaseLoginTest class >> resources [

	^Array with: GlorpDatabaseLoginResource.
]

{ #category : #accessing }
GlorpDatabaseLoginTest >> accessor [

	^accessor.
]

{ #category : #running }
GlorpDatabaseLoginTest >> setUp [
	super setUp.
	login := GlorpDatabaseLoginResource defaultLogin copy.
	accessor := DatabaseAccessor forLogin: login.
]

{ #category : #tests }
GlorpDatabaseLoginTest >> testLogin [
	self assert: self accessor isLoggedIn not.
	self accessor login.
	self assert: self accessor isLoggedIn.
	self accessor logout.
	self assert: self accessor isLoggedIn not
]

{ #category : #tests }
GlorpDatabaseLoginTest >> testSecureLoginDiscardsPassword [
	| oldValue |
	self assert: self accessor isLoggedIn not.
	oldValue := self accessor currentLogin secure.
	[self accessor currentLogin secure: true.
	self accessor login.
	self assert: accessor currentLogin password isNil.
	self accessor logout]
		ensure: [self accessor currentLogin secure: oldValue].
]

{ #category : #tests }
GlorpDatabaseLoginTest >> testUnsecureLoginDoesNotDiscardPassword [
	| oldValue |
	self assert: self accessor isLoggedIn not.
	oldValue := self accessor currentLogin secure.
	[self accessor currentLogin secure: false.
	self accessor login.
	self assert: accessor currentLogin password notNil.
	self accessor logout]
		ensure: [self accessor currentLogin secure: oldValue].
]

{ #category : #tests }
GlorpDatabaseLoginTest >> testUnsuccessfulLogin [

	| anotherAccessor invalidLogin |
	"Some databases can't fail to log in."
	login database supportsAuthentication ifFalse: [^self].

	invalidLogin := GlorpDatabaseLoginResource defaultLogin copy.
	invalidLogin
		password: 'you will never ever guess this password';
		username: 'not a valid user name'.
	anotherAccessor := DatabaseAccessor forLogin: invalidLogin.

	self assert: anotherAccessor isLoggedIn not.
	anotherAccessor loginIfError: [:ex | ].
	self assert: anotherAccessor isLoggedIn not.
	anotherAccessor logout.
]
