tests
testCheckIfInstantiationRequiredForRelationshipNoChange
	"Note that we explicitly register the objects as being old (even though they aren't) so that we don't force instantation of the related objects, which is what we're trying to test."
	| c1 mapping proxy |
	c1 := GlorpCustomer new.
	proxy := Proxy new.
	c1 accounts: proxy.
	session beginUnitOfWork.
	session privateRegisterAsOld: c1.
	mapping := (session descriptorFor: GlorpCustomer) mappingForAttributeNamed: #accounts.
	self deny: (session privateGetCurrentUnitOfWork instantiateIfRequiredFor: c1 mapping: mapping).