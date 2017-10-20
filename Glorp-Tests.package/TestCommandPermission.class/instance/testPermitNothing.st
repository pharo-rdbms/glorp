tests
testPermitNothing
	session accessor permitNothing.
	self should: [session read: GlorpPerson] raise: GlorpIllegalCommand.
	self
		should:
			[session accessor executeCommand: InsertCommand new]
		raise: GlorpIllegalCommand.
	self
		should:
			[session accessor executeCommand: UpdateCommand new]
		raise: GlorpIllegalCommand.
	self
		should:
			[session accessor executeCommand: DeleteCommand new]
		raise: GlorpIllegalCommand.
	self
		should:
			[session accessor
				executeCommand: SQLStringSelectCommand new]
		raise: GlorpIllegalCommand.