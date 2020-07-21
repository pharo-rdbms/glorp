Class {
	#name : #GlorpReadingPersonWithEmailAddressesTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'session',
		'personRow',
		'addressRow',
		'emailAddress1Row',
		'emailAddress2Row',
		'id1',
		'id2',
		'oldReuseState'
	],
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #resources }
GlorpReadingPersonWithEmailAddressesTest class >> resources [
	^Array with: GlorpSessionResource.
]

{ #category : #support }
GlorpReadingPersonWithEmailAddressesTest >> setUp [
	super setUp.
	session := GlorpSessionResource current newSession.
	session beginTransaction.
	addressRow := session system exampleAddressRow.
	session writeRow: addressRow.
	personRow := session system examplePersonRow1.
	session writeRow: personRow.
	emailAddress1Row := session system exampleEmailAddressRow1.
	emailAddress2Row := session system exampleEmailAddressRow2.
	id1 := emailAddress1Row at: (emailAddress1Row table fieldNamed: 'ID').
	id2 := emailAddress2Row at: (emailAddress2Row table fieldNamed: 'ID').
	session writeRow: emailAddress1Row.
	session writeRow: emailAddress2Row.
]

{ #category : #support }
GlorpReadingPersonWithEmailAddressesTest >> tearDown [
	oldReuseState isNil ifFalse:
		[session reusePreparedStatements: oldReuseState].
	session rollbackTransaction.
	session reset.
	session := nil.
]

{ #category : #tests }
GlorpReadingPersonWithEmailAddressesTest >> testObjectsNotAddedTwiceWhenReadingMultipleObjectsOneToMany [
	"Read in the objects first, so they're in cache. Make sure they don't get the collection built up twice."
	| people |

	people := session read: GlorpPerson.
	self testReadMultipleObjectsOneToMany.
	^people.
]

{ #category : #tests }
GlorpReadingPersonWithEmailAddressesTest >> testPreparedStatementsAreFaster [
	"Not really a good test, since there are lots of other factors. And since we don't support this on all dialects/databases, they might easily be the same. Maybe should remove this test, but on the other hand it's the most useful feedback that the prepared statements are actually good for something.  (The tearDown ensures our forcing of reusePreparedStatements is reverted.)"

	| timePrepared timeUnPrepared |
	oldReuseState := session reusePreparedStatements.
	session reusePreparedStatements: true.
	session reset.
	timeUnPrepared := Time millisecondsToRun: [
		session read: GlorpPerson where: [:eachPerson | eachPerson id = 3].
		session read: GlorpPerson where: [:eachPerson | eachPerson id ~= 3].
		session read: GlorpPerson where: [:eachPerson | eachPerson id >= 3]].
	session reset.
	timePrepared := Time millisecondsToRun: [
		3 timesRepeat: [ | query |
			query := Query read: GlorpPerson where: [:eachPerson | eachPerson id = (eachPerson parameter: 1)].
			query executeWithParameters: #(3) in: session]].
	(session accessor numberOfPreparedStatements < 1) ifTrue: [^self "Unsupported, don't bother testing"].
	Transcript cr; show: 'Time reusing prepared statements = ', timePrepared printString.
	Transcript cr; show: 'Time not reusing prepared statements = ', timeUnPrepared printString.
	"Give a little bit of room, so if they take roughly the same amount of time it'll still pass"
	self assert: (timePrepared * 0.8 )< timeUnPrepared.
]

{ #category : #tests }
GlorpReadingPersonWithEmailAddressesTest >> testPreparedStatementsAreReused [
	"The tearDown ensures our forcing of reusePreparedStatements is reverted."
 
	session useBinding ifFalse: [^self].	"test only makes sense if binding is on"
	
	"20160531, pierce: Skip this test for now."	
	session accessor currentLogin database isUDBCSQLite3Platform ifTrue: [ ^ self ].
	
	oldReuseState := session reusePreparedStatements.
	session reusePreparedStatements: true.
	session reset.
	session read: GlorpPerson where: [:eachPerson | eachPerson id = 3].
	session read: GlorpPerson where: [:eachPerson | eachPerson id ~= 3].
	session read: GlorpPerson where: [:eachPerson | eachPerson id >= 3].
	self assert: session accessor numberOfPreparedStatements = 3.
	session reset.
	1 to: 3 do: [:i | | query |
			query := Query read: GlorpPerson where: [:eachPerson | eachPerson id = (eachPerson parameter: 1)].
			query executeWithParameters: (Array with: i) in: session].
	self assert: session accessor numberOfPreparedStatements = 1.
]

{ #category : #tests }
GlorpReadingPersonWithEmailAddressesTest >> testReadMultipleObjectsOneToMany [
	| query result person addresses |

	query := Query read: GlorpPerson where: [:eachPerson | eachPerson id = 3].
	query alsoFetch: [:each | each emailAddresses].
	result := query executeIn: session.
	self assert: result size = 1.
	person := result first.
	addresses := person emailAddresses.
	self deny: addresses isGlorpProxy.
	self assert: addresses size = 2.
	self 
		assert: (addresses first id = id1 or: [addresses last id = id1]).
	self 
		assert: (addresses first id = id2 or: [addresses last id = id2]).
	self assert: addresses first id ~= addresses last id.
]

{ #category : #tests }
GlorpReadingPersonWithEmailAddressesTest >> testReadPersonWithEmailAddresses [
	| query result emailAddresses |
	query := Query
		readOneOf:GlorpPerson
		where: [:person | person id = 3].
	result := query executeIn: session.
	emailAddresses := result emailAddresses getValue.
	self assert: emailAddresses size = 2.
	self
		assert:
			(emailAddresses first id = id1 or: [emailAddresses last id = id1]).
	self
		assert:
			(emailAddresses first id = id2 or: [emailAddresses last id = id2]).
	self assert: emailAddresses first id ~= emailAddresses last id.
]
