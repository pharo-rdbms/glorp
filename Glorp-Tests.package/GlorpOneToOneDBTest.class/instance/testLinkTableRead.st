tests-link table
testLinkTableRead
	| customers |
	system := GlorpLinkTableAnywhereDescriptorSystem forPlatform: system platform.
	session system: system.
	self inTransactionDo: [
		self writeCustomersWithOneAccountEach.
		session reset.
		customers := session read: GlorpCustomer.
		self assert: ((customers collect: [:each | each accounts id]) asSortedCollection asArray = #(22 9874))].