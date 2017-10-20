tests
testProxying
	| customers |
	session beginTransaction.
	[((system descriptorFor: GlorpPerson) mappingForAttributeNamed: #name) shouldProxy: true.
	session modify: GlorpPerson example1 in: [].
	session reset.
	customers := session read: GlorpPerson.
	self assert: customers first name isGlorpProxy.
	self deny: customers first name isInstantiated.
	self assert: customers first name = 'Zaphod Beeblebrox']
		ensure: [session rollbackTransaction].
	self deny: ((system descriptorFor: GlorpPerson) mappedFields includes: ((system tableNamed: 'PERSON') fieldNamed: 'NAME')).