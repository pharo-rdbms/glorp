tests-forcing update
testRegisteringAndForcingUpdateToDatabase
	"Test going round trip to the database with forceSaveOf:. This doesn't assert much, but is mostly to make sure we aren't doing an insert instead of an update."

	| customer otherCustomer |
	session beginTransaction.
	customer := GlorpCustomer example1 id: 7.
	otherCustomer := GlorpCustomer example2 id: 8.
	session modifyAll: (Array with: customer with: otherCustomer) in: [].
	session inUnitOfWorkDo: [
		session register: otherCustomer.
		session save: customer].
	session rollbackTransaction.