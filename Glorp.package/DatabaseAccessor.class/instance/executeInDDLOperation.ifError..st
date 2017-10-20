transactions
executeInDDLOperation: aBlock ifError: errorBlock
	"Execute DDL SQL - something which creates/drops/modifies tables or other schema information. The main reason for this method is that some databases require a transaction, while others don't require it, and still others don't allow it. Try to do the right thing."

	^ self doDDLOperation: [
		self
			execute: aBlock
			ifError: errorBlock ]