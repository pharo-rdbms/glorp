Class {
	#name : #GlorpReadingPersonWithoutEmailAddressesTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'session',
		'personRow'
	],
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #resources }
GlorpReadingPersonWithoutEmailAddressesTest class >> resources [
	^Array with: GlorpSessionResource.
]

{ #category : #running }
GlorpReadingPersonWithoutEmailAddressesTest >> setUp [

	super setUp.
	session := GlorpSessionResource current newSession.
	session beginTransaction.
	personRow := session system examplePersonRow2.
	session writeRow: personRow.

]

{ #category : #running }
GlorpReadingPersonWithoutEmailAddressesTest >> tearDown [

	session rollbackTransaction.
	session reset.
	session := nil.
	super tearDown
]

{ #category : #tests }
GlorpReadingPersonWithoutEmailAddressesTest >> testReadMultipleObjectsOneToMany [

	| query result person addresses |

	query := Query read: GlorpPerson where: [ :eachPerson | eachPerson id = 4 ].
	query alsoFetch: [ :each | each emailAddresses asOuterJoin ].
	result := query executeIn: session.
	self assert: result size equals: 1.
	person := result first.
	addresses := person emailAddresses.
	self deny: addresses isGlorpProxy "testing PR https://github.com/pharo-rdbms/glorp/pull/115".
	self assert: addresses size equals: 0
]
