tests-read
testReadActionWithCollection
	| collection |
	self
		inTransactionDo:
			[collection := OrderedCollection new.
			self writePersonWithEmailAddresses.
			((session system descriptorFor: GlorpPerson)
				mappingForAttributeNamed: #emailAddresses)
				proxyAction:
					[:owner :object | object do: [:each | collection add: owner -> each]].
			person := session readOneOf: GlorpPerson.
			person emailAddresses yourSelf.
			self assert: collection size = 2.
			self assert: collection first = (person -> person emailAddresses first).
			self assert: collection last = (person -> person emailAddresses last)].