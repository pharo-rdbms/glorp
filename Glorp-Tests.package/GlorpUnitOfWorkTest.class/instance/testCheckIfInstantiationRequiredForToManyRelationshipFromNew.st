tests
testCheckIfInstantiationRequiredForToManyRelationshipFromNew
	"Note that we force the object to be registered as new, just to make absolutely sure it's being treated as a new object."
	| c1 proxy |
	c1 := GlorpCustomer new.
	proxy := Proxy new.
	proxy session: session.
	c1 accounts: proxy.
	session beginUnitOfWork.
	session privateRegisterAsNew: c1.
	self assert: (proxy isInstantiated).