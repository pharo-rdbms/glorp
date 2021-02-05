Class {
	#name : #GlorpFilteredInheritanceTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'session',
		'allEmployees'
	],
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #'as yet unclassified' }
GlorpFilteredInheritanceTest class >> resources [
	^Array with: GlorpDatabaseLoginResource with: GlorpDemoTablePopulatorResource with: GlorpSessionResource
]

{ #category : #tests }
GlorpFilteredInheritanceTest >> compareEmployees: employees [

	employees do: [:each |
		| corresponding |
		corresponding := allEmployees detect: [:eachOriginal | each id = eachOriginal id].
		self assert: corresponding = each].
]

{ #category : #tests }
GlorpFilteredInheritanceTest >> makeSupertaxIn: aCollection [
	| previous newTax |
	previous := aCollection last.
	newTax := (GlorpBasicTax new)
		name: (String with: (Character value: previous name first asInteger + 1));
		yourself.
	previous addTax: newTax.
	aCollection add: newTax.
]

{ #category : #support }
GlorpFilteredInheritanceTest >> setUp [
	super setUp.
	session := GlorpSessionResource current newSession.
	session system: (GlorpInheritanceDescriptorSystem forPlatform: GlorpDatabaseLoginResource defaultLogin database).
]

{ #category : #support }
GlorpFilteredInheritanceTest >> tearDown [
	super tearDown.
	session reset.
	session := nil.
]

{ #category : #tests }
GlorpFilteredInheritanceTest >> testCacheLookup [
	"Ask for an Employee which should be from the cache and which should return a Manager."

	| manager employee |
	session beginTransaction.
	
	[session beginUnitOfWork.
	self writeTestHarness.
	session commitUnitOfWork.
	session initializeCache.
	manager := session readOneOf: GlorpManager
				where: [:each | each id = 3 ].
	self assert: (session cacheLookupForClass: GlorpEmployee key: 3) == manager.
	employee := session readOneOf: GlorpEmployee
				where: [:each | each id = 3 ].
	self assert: employee == manager.

	manager := session readOneOf: GlorpRegionalManager
				where: [:each | each id = 12 ].
	employee := session readOneOf: GlorpEmployee
				where: [:each | each id = 12 ].
	self assert: employee == manager.

	employee := session readOneOf: GlorpManager
				where: [:each | each id = 11 ].
	manager := session readOneOf: GlorpEmployee
				where: [:each | each id = 11 ].
	self assert: employee == manager.

	"Test that the cache refuses to return an object which is not of the proper class or subclass."
	employee := session readOneOf: GlorpEmployee
				where: [:each | each id = 4 ].
	self assert: (session privateGetCache lookupClass: GlorpRegionalManager key: 4 ifAbsent: []) isNil.
	manager := session readOneOf: GlorpRegionalManager
				where: [:each | each id = 4 ].
	self assert: manager isNil.

	"Proxys seem to try a cache lookup before they execute their query...can we write a test which fails due to this?"] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpFilteredInheritanceTest >> testDirectQuery [
	"Ask for all Employees, see if we get subclasses too"

	| employees offices |
	session beginTransaction.
	
	[session beginUnitOfWork.
	self writeTestHarness.
	session commitUnitOfWork.
	session initializeCache.
	employees := true 
				ifTrue: [session read: GlorpEmployee where: [:each | each name = 'Bob']]
				ifFalse: [session halt read: GlorpEmployee].
	self assert: employees size = 8.
	self 
		assert: (employees select: [:emp | emp isMemberOf: GlorpEmployee]) size = 1.
	self assert: (employees select: [:emp | emp isMemberOf: GlorpManager]) size = 2.
	self 
		assert: (employees select: [:emp | emp isMemberOf: GlorpLineWorker]) size = 4.
	self 
		assert: (employees select: [:emp | emp isMemberOf: GlorpRegionalManager]) size 
				= 1.
	self compareEmployees: employees.
	session initializeCache.
	offices := session readOneOf: GlorpOffice
				where: [:each | each employeeOfMonth name = 'Bob'].	"There is no regional manager with id = 4 but we can ensure that the type info is getting into the query's key by asking for one and seeing that it doesn't exist"
	session initializeCache.
	self 
		assert: (session readOneOf: GlorpRegionalManager where: [:each | each id = 4]) 
				== nil] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpFilteredInheritanceTest >> testDirectQuery2 [
	"Ask for all Employees, see if we get subclasses too"

	| employees |
	session beginTransaction.
	
	[session beginUnitOfWork.
	self writeTestHarness.
	session commitUnitOfWork.
	session initializeCache.
	employees := session read: GlorpEmployee.
	self assert: employees size = 12.
	self 
		assert: (employees select: [:emp | emp isMemberOf: GlorpEmployee]) size = 2.
	self assert: (employees select: [:emp | emp isMemberOf: GlorpManager]) size = 3.
	self 
		assert: (employees select: [:emp | emp isMemberOf: GlorpLineWorker]) size = 5.
	self 
		assert: (employees select: [:emp | emp isMemberOf: GlorpRegionalManager]) size 
				= 2.
] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpFilteredInheritanceTest >> testDirectQueryWithAbstractClass [
	| fromdb |
	session beginTransaction.
	[session inUnitOfWorkDo: [	session register: (GlorpBasicTax new name: 'Tax'; yourself).
								session register: (GlorpSurcharge new name: 'Surcharge'; yourself)].
	session reset.
	fromdb := session read: GlorpTax.
	self assert: fromdb size = 2.
	self assert: (fromdb select: [:emp | emp isMemberOf: GlorpTax]) isEmpty.
	self assert: (fromdb select: [:emp | emp isMemberOf: GlorpBasicTax]) size = 1.
	self assert: (fromdb select: [:emp | emp isMemberOf: GlorpSurcharge]) size = 1] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpFilteredInheritanceTest >> testNotInSelect [
	"Ask for an Employee which should be from the cache and which should return a Manager."

	| testEmployees |
	session beginTransaction.
	
	[session beginUnitOfWork.
	self writeTestHarness.
	session commitUnitOfWork.
	testEmployees := session read: GlorpManager
				where: [:each | each id notIn: #(1 2 3)].
	self assert: testEmployees notEmpty

	"Proxys seem to try a cache lookup before they execute their query...can we write a test which fails due to this?"] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpFilteredInheritanceTest >> testOrderBy [
	| employees query |
	session beginTransaction.
	
	[session beginUnitOfWork.
	self writeTestHarness.
	session commitUnitOfWork.
	query := Query read: GlorpEmployee
				where: [:each | each id <= 4].
	query orderBy: #name.
	query orderBy: #id.
	employees := session execute: query.
	self assert: (employees asSortedCollection: [:a :b | a name = b name ifTrue: [
		a id <= b id] ifFalse: [a name < b name]]) asArray = employees]
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpFilteredInheritanceTest >> testRelationshipQuery [
	"Ask for all Employees in a given office and test that the return types are correct."

	| employees office |
	session beginTransaction.
	
	[session beginUnitOfWork.
	self writeTestHarness.
	session commitUnitOfWork.
	session initializeCache.
	office := session readOneOf: GlorpOffice
				where: [:each | each id = 1 ].
	employees := office employees.
	self assert: employees size = 6.
	self assert: (employees select: [:emp | emp isMemberOf: GlorpEmployee]) size = 2.
	self assert: (employees select: [:emp | emp isMemberOf: GlorpManager]) size = 1.
	self assert: (employees select: [:emp | emp isMemberOf: GlorpLineWorker]) size = 2.
	self assert: (employees select: [:emp | emp isMemberOf: GlorpRegionalManager]) size = 1] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpFilteredInheritanceTest >> testTaxInsertOrdering [
	| taxes first |
	taxes := OrderedCollection new.
	first := (GlorpBasicTax new)
		name: 'A';
		yourself.
	taxes add: first.
	10 timesRepeat: [self makeSupertaxIn: taxes].
	[session beginTransaction.
	session inUnitOfWorkDo: [session registerAll: taxes]]
		ensure: [session rollbackTransaction].
]

{ #category : #support }
GlorpFilteredInheritanceTest >> writeTestHarness [
	| office1 office2  eom1 eom2 jim bob |
	session register: (office1 := GlorpOffice new id: 1; yourself).
	session register: (office2 := GlorpOffice new id: 2; yourself).
	office1 addEmployee: (eom1 := GlorpEmployee new id: 1; name: 'Bob'; yourself).
	office1 addEmployee: (GlorpEmployee new id: 2; name: 'Jim'; yourself).
	office1 addEmployee: (GlorpManager new id: 3; name: 'Bob'; branch: 'West'; yourself).
	office2 addEmployee: (eom2 := GlorpManager new id: 4; name: 'Steve'; branch: 'East'; yourself).
	office2 addEmployee: (GlorpManager new id: 5; name: 'Bob'; branch: 'South'; yourself).
	office1 addEmployee: (GlorpLineWorker new id: 6; name: 'Wally'; productionLine: 'Gold'; yourself).
	office1 addEmployee: (GlorpLineWorker new id: 7; name: 'Bob'; productionLine: 'Silver'; yourself).
	office2 addEmployee: (GlorpLineWorker new id: 8; name: 'Bob'; productionLine: 'Tin'; yourself).
	office2 addEmployee: (GlorpLineWorker new id: 9; name: 'Bob'; productionLine: 'Copper'; yourself).
	office2 addEmployee: (GlorpLineWorker new id: 10; name: 'Bob'; productionLine: 'Steel'; yourself).
	office1 addEmployee: (GlorpRegionalManager new id: 11; name: 'Bob'; branch: 'South'; region: 'MidWest'; yourself).
	office2 addEmployee: (GlorpRegionalManager new id: 12; name: 'Mike'; branch: 'North'; region: 'NorthEast'; yourself).
	office1 employeeOfMonth: eom1.
	office2 employeeOfMonth: eom2.

	session register: (jim := GlorpWorkingStiff new id: 13; name: 'Jim'; yourself).
	session register: (bob := GlorpWorkingStiff new id: 14; name: 'Bob'; yourself).

	allEmployees := (Array with: jim with: bob), office1 employees, office2 employees.
]
