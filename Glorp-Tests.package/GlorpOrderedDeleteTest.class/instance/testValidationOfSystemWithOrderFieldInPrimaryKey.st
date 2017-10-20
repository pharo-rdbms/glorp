running
testValidationOfSystemWithOrderFieldInPrimaryKey
	"A mapping with a link table and which writes the order field must define primary key fields and must not include the order field as a primary key.  If we remove the primary key fields from the ordered link table, it will make all the fields primary, including the order field, so should raise a validation error."

	session system giveOrderedLinkTableNoPrimaryKeyFields.
	self
		should: [session system validate]
		raise: Error
		description:  'Validation of this system should have failed'.