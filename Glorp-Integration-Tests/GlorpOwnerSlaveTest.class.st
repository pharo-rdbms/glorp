Class {
	#name : #GlorpOwnerSlaveTest,
	#superclass : #GlorpMappingDBTest,
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #tests }
GlorpOwnerSlaveTest >> test1 [
	| owner slaves table field |
	self
		inTransactionDo:
			[owner := GlorpOwner new.
			owner id: 1.
			slaves := OrderedCollection new.
			1 to: 5 do: [:id | slaves add: (GlorpSlave new id: id)].
			owner slaves: slaves.
			owner slave: slaves last.
			session beginUnitOfWork.
			session register: owner.
			session commitUnitOfWork.
			session reset.
			owner := session readOneOf: GlorpOwner where: [:each | each id = 1].
			self assert: owner slaves isEmpty not.
			table := session system tableNamed: 'GLORP_SLAVE'.
			field := table fieldNamed: 'OWNER_ID'.
			slaves := session
				read: GlorpSlave
				where: [:each | ((each getTable: table) getField: field) ~= nil].
			self assert: slaves size = 5].
]

{ #category : #tests }
GlorpOwnerSlaveTest >> testSortOrder [
	"Validate that it doesn't matter what order we put in the input, the tables come out in the correct sort order."
	| justTheseTables sorted sorted2 |
	justTheseTables := Array with: (system tableNamed: 'GLORP_OWNER') with: (system tableNamed: 'GLORP_SLAVE').
	sorted := (TableSorter for: justTheseTables) sort.
	sorted2 := (TableSorter for: justTheseTables reverse) sort.
	self assert: sorted = sorted2.
	self assert: sorted first name = 'GLORP_SLAVE'.
]
