support
testWriteWithDefaultValue

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