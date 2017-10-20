tests
testCheckIfInstantiationRequiredForDirectMapping
	| c1 mapping proxy |
	c1 := GlorpCustomer new.
	proxy := Proxy new.
	c1 name: proxy.
	session beginUnitOfWork.
	session register: c1.
	mapping := (session descriptorFor: GlorpCustomer) mappingForAttributeNamed: #name.
	self deny: (session privateGetCurrentUnitOfWork instantiateIfRequiredFor: c1 mapping: mapping).