tests-forcing update
testRegisteringAndForcingUpdate
	"Test that we can force the first customer to be rewritten, even if it hasn't been modified by using the #forceSaveOf: call."

	| customer triedToWrite row table map otherCustomer |
	session beginTransaction.
	customer := GlorpCustomer example1 id: 7.
	otherCustomer := GlorpCustomer example2 id: 8.
	session modify: (Array with: customer with: otherCustomer) in: [].
	session accessor denyWrites.
	session modify: customer in: [].
	session beginUnitOfWork.
	session register: otherCustomer.
	session save: customer.
	[session commitUnitOfWork] on: GlorpIllegalCommand do: [:ex |
		triedToWrite := true.
		table := session system tableNamed: 'GR_CUSTOMER'.
		map := session privateGetCurrentUnitOfWork privateGetRowMap subMapForTable: table.
		row := map at: map keys asArray first.
		self assert: (row at: row fields first) = 7.
		self assert: (row at: row fields last) = 'Fred Flintstone'.
		self assert: map size = 1.
	].
	self assert: triedToWrite.
	session rollbackTransaction.