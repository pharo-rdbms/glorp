tests-key in different tables
testWriteAndReadBackKeyInTargetTable

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
	self assert: withEmps employees size = 2.
	self assert: withEmps employees keys asSortedCollection asArray = #('CEO' 'Editor').
	self assert: (withEmps employees at: 'CEO') name = 'The Boss'.
	self assert: (withEmps employees at: 'Editor') name = 'Somebody'.