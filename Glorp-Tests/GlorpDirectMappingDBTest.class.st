Class {
	#name : #GlorpDirectMappingDBTest,
	#superclass : #GlorpMappingDBTest,
	#instVars : [
		'person',
		'personId'
	],
	#category : 'Glorp-Tests-Database'
}

{ #category : #tests }
GlorpDirectMappingDBTest >> readPerson [
	| results query |
	query := Query
		read: GlorpPerson
		where: [:pers | pers id = personId].
	results := query executeIn: session.
	self assert: results size = 1.
	person := results first.
]

{ #category : #tests }
GlorpDirectMappingDBTest >> testMappingToSubselect [

	| personDescriptor people |
	[session beginTransaction.
	self writeAddress.
	self writeHomelessPerson.
	self writePersonWithEmailAddresses.
	personDescriptor := system descriptorFor: GlorpPerson.
	(personDescriptor newMapping: DirectMapping)
		beReadOnly;
		type: Boolean;
		from: #hasEmail 
		to: [:each | each emailAddresses notEmpty].
	people := session read: GlorpPerson orderBy: #id.
	self assert: people first hasEmail.
	self deny: people last hasEmail.
	self assert: people first emailAddresses notEmpty.
	self assert: people last emailAddresses isEmpty.
	 ]
		ensure: [session rollbackTransaction].
]

{ #category : #tests }
GlorpDirectMappingDBTest >> testReadWithDirectFieldReference [

	| peopleWithAddresses peopleWithoutAddresses addressIdField |
	[session beginTransaction.
	self writeAddress.
	self writeHomelessPerson.
	self writeHomefulPerson.
	addressIdField := (session system tableNamed: 'PERSON') fieldNamed: 'ADDRESS_ID'.
	peopleWithAddresses := session read: GlorpPerson where: [:each | (each getField: addressIdField) notNIL].
	peopleWithoutAddresses := session read: GlorpPerson where: [:each | (each getField: addressIdField) isNIL].
	self assert: peopleWithAddresses size = 1.
	self assert: peopleWithoutAddresses size = 1.
	self assert: peopleWithAddresses first id = 3.
	self assert: peopleWithoutAddresses first id = 4.
	 ]
		ensure: [session rollbackTransaction].
]

{ #category : #tests }
GlorpDirectMappingDBTest >> testReadWithPseudoVariableMapping [

	| peopleWithAddresses peopleWithoutAddresses |
	[session beginTransaction.
	self writeAddress.
	self writeHomelessPerson.
	self writeHomefulPerson.
	peopleWithAddresses := session read: GlorpPerson where: [:each | each addressId notNIL].
	peopleWithoutAddresses := session read: GlorpPerson where: [:each | each addressId isNIL].
	self assert: peopleWithAddresses size = 1.
	self assert: peopleWithoutAddresses size = 1.
	self assert: peopleWithAddresses first id = 3.
	self assert: peopleWithoutAddresses first id = 4.]
		ensure: [session rollbackTransaction].
]

{ #category : #tests }
GlorpDirectMappingDBTest >> testUpdate [
	|newPerson |
	self inTransactionDo: [
		session beginUnitOfWork.
		newPerson := GlorpPerson example1.
		personId := newPerson id.
		session register: newPerson.
		session commitUnitOfWork.
		session reset.
		self readPerson.
		session inUnitOfWorkDo: [
			session register: person.
			person name: 'something else'].
		session reset.
		self readPerson.
		self assert: person id = newPerson id.
		self assert: person name = 'something else'].
]

{ #category : #support }
GlorpDirectMappingDBTest >> testUpdateWithDefaultValue [
	"Check that default values don't revert if we update the object in some other way.  (This test does not in fact error in Glorp 7.7 - 69 and earlier, so needs revision.)"

	self inTransactionDo:
		[| thing |
		session transact: [thing := DefaultableThing new id: 1].
		session reset.
		thing := session readOneOf: DefaultableThing.
		self assert: thing integer = 4.
		session modify: thing in: [thing integer: 7].
		session reset.
		thing := session readOneOf: DefaultableThing.
		session modify: thing in: [thing boolean: true].
		self assert: thing integer = 7].
]

{ #category : #support }
GlorpDirectMappingDBTest >> testWriteWithDefaultValue [

	| rawDBResult field converter dbValue raw |
	self inTransactionDo: [
		| thing |
		session transact: [thing := DefaultableThing new id: 1].
		session reset.
		thing := session readOneOf: DefaultableThing.
		self assert: thing boolean = false.
		field := (system tableNamed: 'DEFAULTABLE_THING') fieldNamed: 'MY_BOOL'.
		converter := field converterForStType: Boolean.
		dbValue := converter convert: false toDatabaseRepresentationAs: field type.
		rawDBResult := session accessor executeSQLString: 'select MY_BOOL from DEFAULTABLE_THING'.
		"The conversion back might get done by us, or might get done by the EXDI layer, Accomodate either possibility as long as it comes out to something equivalent to what we thought it ought to be."
		raw := rawDBResult first first.
		self assert: (raw = dbValue or: [raw = false]).
		self assert: thing integer = 4].
]

{ #category : #support }
GlorpDirectMappingDBTest >> writeAddress [
	| addressRow |
	addressRow := session system exampleAddressRow.
	session writeRow: addressRow.
]

{ #category : #support }
GlorpDirectMappingDBTest >> writeHomefulPerson [
	| personRow |
	personRow := session system examplePersonRow1.
	session writeRow: personRow.
	personId := personRow atFieldNamed: 'ID'.
]

{ #category : #support }
GlorpDirectMappingDBTest >> writeHomelessPerson [
	| personRow |
	personRow := session system examplePersonRow2.
	session writeRow: personRow.
	personId := personRow atFieldNamed: 'ID'.
]

{ #category : #support }
GlorpDirectMappingDBTest >> writePersonWithEmailAddresses [
	| personRow emailAddress1Row emailAddress2Row |
	personRow := session system examplePersonRow1.
	personId := personRow atFieldNamed: 'ID'.
	session writeRow: personRow.
	emailAddress1Row := session system exampleEmailAddressRow1.
	emailAddress2Row := session system exampleEmailAddressRow2.
	emailAddress1Row at: (emailAddress1Row table fieldNamed: 'ID').
	emailAddress2Row at: (emailAddress2Row table fieldNamed: 'ID').
	session writeRow: emailAddress1Row.
	session writeRow: emailAddress2Row.
]
