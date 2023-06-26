Class {
	#name : #GlorpSessionResource,
	#superclass : #TestResource,
	#instVars : [
		'session'
	],
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #resources }
GlorpSessionResource class >> resources [

	^Array with: GlorpDatabaseLoginResource with: GlorpDemoTablePopulatorResource.
]

{ #category : #'private - running' }
GlorpSessionResource >> glorpTestsSystem [
	"We want to prep the GlorpDemoTablePopulatorResource but subclasses using different systems may not;  put it here where it will be overridden."

	GlorpDemoTablePopulatorResource current.
	^GlorpDemoDescriptorSystem forPlatform: GlorpDatabaseLoginResource defaultLogin database
]

{ #category : #accessing }
GlorpSessionResource >> newSession [

	self setUp.
	^self session.
]

{ #category : #accessing }
GlorpSessionResource >> session [

	^session.
]

{ #category : #'private - running' }
GlorpSessionResource >> setAccessor [
	
	session accessor: GlorpDatabaseLoginResource current accessor.
]

{ #category : #running }
GlorpSessionResource >> setUp [

	super setUp.
	session := self glorpTestsSystem sessionForLogin:
		           GlorpDatabaseLoginResource current login.
	self setAccessor
]

{ #category : #running }
GlorpSessionResource >> tearDown [

	session logout.
	super tearDown
]
