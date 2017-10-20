tests
testCheckIfInstantiationRequiredForRelationshipInstantiatedProxy
	| c1 mapping proxy |
	c1 := GlorpCustomer new.
	proxy := Proxy new.
	proxy query: (GlorpQueryStub new session: session; result: 'foo').
	proxy session: session.
	proxy yourSelf.
	c1 accounts: proxy.
	session beginUnitOfWork.
	session register: c1.
	c1 accounts: #().
	mapping := (session descriptorFor: GlorpCustomer) mappingForAttributeNamed: #accounts.
	self deny: (session privateGetCurrentUnitOfWork instantiateIfRequiredFor: c1 mapping: mapping).