Class {
	#name : #GlorpSessionResource,
	#superclass : #TestResource,
	#instVars : [
		'session'
	],
	#category : 'Glorp-Tests-Database'
}

{ #category : #resources }
GlorpSessionResource class >> resources [

	^Array with: GlorpDatabaseLoginResource with: GlorpDemoTablePopulatorResource.
]

{ #category : #setup }
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

{ #category : #setup }
GlorpSessionResource >> setAccessor [
	
	session accessor: GlorpDatabaseLoginResource current accessor.
]

{ #category : #setup }
GlorpSessionResource >> setUp [
	super setUp.
	session := self glorpTestsSystem
		sessionForLogin: GlorpDatabaseLoginResource current login.
	self setAccessor.
]

{ #category : #setup }
GlorpSessionResource >> tearDown [
	session logout.
	super tearDown.
]
