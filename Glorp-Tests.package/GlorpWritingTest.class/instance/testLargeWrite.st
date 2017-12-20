tests
testLargeWrite
	"This is really just a performance test. No assertions. It should take on the order of 10 seconds. If it starts taking 10 minutes, it indicates a potential problem...."
	| customer |
	self timeLimit: 180 seconds.
	session beginTransaction.
	[customer := GlorpCustomer new.
	customer name: 'foo'.
     customer id: 123.
	1 to: 5000 do: [:i | | transaction |
		transaction := GlorpBankTransaction new.
		transaction amount amount: i.
		customer addTransaction: transaction].
	session beginUnitOfWork.
	session register: customer.
	session commitUnitOfWork]
		ensure: [session rollbackTransaction].