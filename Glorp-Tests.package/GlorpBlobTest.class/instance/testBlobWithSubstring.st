tests
testBlobWithSubstring
	"Test our ability to query with substring against a blob. This is severely limited in Postgresql, and may be limited in others.
	The compare blocks once looked clean, like this:
		[:each | (each test copyFrom: 1 to: 3) = 'hgf'].
	but the DB2 compare blocks would need to look like this:
		[:each | (each test copyFrom: 1 to: 3) like: 'hgf'].
	Rather than duplicate the blocks, the operator was switched to:
		[:each | (each test copyFrom: 1 to: 3) perform: compare with: 'hgf'].
	which results in the desired SQL, although in code it looks unpleasant."

	| result system compare |
	session platform supportsStringQueryOnBlobs ifFalse: [^self knownFailure].
	compare := session platform isDB2Platform
		ifTrue: [ #like: ]
		ifFalse: [ #= ].
	stType := String.
	self inTransactionDo: [
		system := self systemFor: table.
		session system: system.
		session inUnitOfWorkDo: [
			| model |
			model := GlorpTypeTestsModelClass new test: 'hgfedcbazyx'.
			session register: model].
		session reset.
		result := session read: GlorpTypeTestsModelClass where: [:each | (each test copyFrom: 1 to: 3) perform: compare with: 'hgf'].
		self assert: result size = 1.
		result := session read: GlorpTypeTestsModelClass where: [:each | (each test copyFrom: 1 to: 3) perform: compare with: 'abc'].
		self assert: result size = 0.
		result := session read: GlorpTypeTestsModelClass where: [:each | (each test copyFrom: 4 to: 6) perform: compare with: 'edc'].
		self assert: result size = 1.
		result := session read: GlorpTypeTestsModelClass where: [:each | (each test copyFrom: 7 to: 9) perform: compare with: 'baz'].
		self assert: result size = 1.

		result := session read: GlorpTypeTestsModelClass where: [:each | (each test copyFrom: 1 to: 6) perform: compare with: 'hgfedc'].
		self assert: result size = 1].