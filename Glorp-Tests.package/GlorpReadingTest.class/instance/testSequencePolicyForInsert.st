tests
testSequencePolicyForInsert
	| testObject |

	GlorpInMemorySequenceDatabaseType reset.
	[session beginTransaction.
	session beginUnitOfWork.
	testObject := GlorpAirline new.
	session register: testObject.
	session commitUnitOfWork.
	self assert: testObject id = 1]
		ensure: [session rollbackTransaction]