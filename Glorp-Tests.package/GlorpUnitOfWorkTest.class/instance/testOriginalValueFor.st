tests
testOriginalValueFor
	| c1 mapping |
	c1 := GlorpCustomer new.
	c1 name: 'fred'.
	session beginUnitOfWork.
	session register: c1.
	c1 name: 'barney'.
	mapping := (session descriptorFor: GlorpCustomer) mappingForAttributeNamed: #name.
	self assert: (session privateGetCurrentUnitOfWork originalValueFor: c1 mapping: mapping) = 'fred'.