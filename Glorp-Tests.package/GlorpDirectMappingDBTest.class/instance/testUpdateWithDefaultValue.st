support
testUpdateWithDefaultValue
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