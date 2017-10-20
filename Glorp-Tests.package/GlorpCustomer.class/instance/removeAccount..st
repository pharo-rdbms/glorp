accessing
removeAccount: aBankAccount

	accounts remove: aBankAccount.
	aBankAccount basicRemoveHolder: self.