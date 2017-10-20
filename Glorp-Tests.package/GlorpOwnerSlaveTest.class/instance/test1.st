tests
test1
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