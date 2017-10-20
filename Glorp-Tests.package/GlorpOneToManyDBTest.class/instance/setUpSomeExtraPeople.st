tests-join
setUpSomeExtraPeople
	self
		inUnitOfWorkDo:
			[| otherPerson |
			session register: (GlorpPerson new id: 9924365).
			otherPerson := GlorpPerson new id: 12121.
			otherPerson
				emailAddresses:
					(OrderedCollection
						with:
							((GlorpEmailAddress new)
								id: 7;
								host: 'asdfasdf')).
			session register: otherPerson]
		initializeWith: [self writePersonWithEmailAddresses].