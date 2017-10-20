tests-read
testReadAction
	| collection |
	self
		inTransactionDo:
			[collection := OrderedCollection new.
			self writePersonWithAddress.
			((session system descriptorFor: GlorpPerson)
				mappingForAttributeNamed: #address)
				proxyAction: [:owner :object | collection add: owner -> object].
			person := session readOneOf: GlorpPerson.
			person address yourSelf.
			self assert: collection size = 1.
			self assert: collection first = (person -> person address yourSelf)].