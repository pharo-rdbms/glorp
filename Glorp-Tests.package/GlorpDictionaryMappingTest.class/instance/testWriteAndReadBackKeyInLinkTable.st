tests-key in different tables
testWriteAndReadBackKeyInLinkTable

	| query readBackPublishers publishers withEmps |
	publishers := session system examplePublishers.
	session transact: [session register: publishers].
	session reset.
	query := Query read: GlorpPublisher.
	query orderBy: [:each | each name].
	readBackPublishers := session execute: query.
	self assert: readBackPublishers size = 3.
	withEmps := readBackPublishers at: 2.
	self assert: withEmps name = 'Cambridge'.
	self assert: withEmps differentBunchOfEmployeesById size = 2.
	self assert: withEmps differentBunchOfEmployeesById keys asSortedCollection asArray = #(3 4).
	self assert: (withEmps differentBunchOfEmployeesById at: 3) name = 'Contractor 1'.
	self assert: (withEmps differentBunchOfEmployeesById at: 4) name = 'Contractor 2'.