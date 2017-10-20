tests
testNoWriteValidation
	| |
	(session system descriptorFor: GlorpBankBranch) mappings next readOnly: false.
	self should: [session system validate] raise: Dialect error.