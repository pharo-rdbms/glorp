tests
testNonIntrusiveAlsoFetch
	| alsoFetchQuery query results | 

	"If a platform has no outer joins (!) we cannot execute
	 this test."
	(session system platform supportsANSIJoins or: [
		session system platform useMicrosoftOuterJoins or: [
		session system platform useOracleOuterJoins ]])
			ifFalse: [ ^self ].

	[session beginTransaction.
	session beginUnitOfWork.
	session register: GlorpPerson example1.
	session register: (GlorpPerson example1
							id: 2;
							address: nil;
							yourself).
	session commitUnitOfWork.
	alsoFetchQuery := Query
						read: GlorpPerson
						where: nil.
	alsoFetchQuery alsoFetch: [:ea | ea address asOuterJoin].
	query := Query
					read: GlorpPerson
					where: nil.
	results := alsoFetchQuery executeIn: session.
	self assert: results size = 2.
	results := query executeIn: session.
	self assert: results size = 2] 
			ensure: [session rollbackTransaction].