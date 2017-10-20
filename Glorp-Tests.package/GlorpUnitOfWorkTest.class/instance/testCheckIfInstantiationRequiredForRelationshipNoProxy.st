tests
testCheckIfInstantiationRequiredForRelationshipNoProxy
	| c1 mapping |
	c1 := GlorpCustomer new.
	c1 accounts: #().
	session beginUnitOfWork.
	session register: c1.
	c1 accounts: nil.
	mapping := (session descriptorFor: GlorpCustomer) mappingForAttributeNamed: #accounts.
	self deny: (session privateGetCurrentUnitOfWork instantiateIfRequiredFor: c1 mapping: mapping).