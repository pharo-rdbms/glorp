tests
testGetFieldAmbiguous
	| |
	self 
		should: [[:pass | pass getField: 'ID']
			asGlorpExpressionForDescriptor: (system descriptorFor: GlorpPassenger)]
		raise: Dialect error.