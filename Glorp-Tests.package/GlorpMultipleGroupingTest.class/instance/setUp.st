support
setUp
	"We beginTransaction to be already in transaction on entering #transact:, so #transact will not commit if the transaction succeeds;  instead, #tearDown will roll it back, clean for the next test run."

	super setUp.
	session system: GlorpLockingDescriptorSystem new.
	session beginTransaction.
	session transact:
		[session system example2 do:
			[:each | session register: each]].