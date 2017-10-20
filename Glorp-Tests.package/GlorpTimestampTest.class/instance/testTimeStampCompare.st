tests
testTimeStampCompare
	| record time newRecord |
	session system: (GlorpDemoDescriptorSystem forPlatform: session platform).
	self
		inTransactionDo:
			[record := (GlorpRecordWithUpdateTime new)
				id: 12;
				name: 'thing'.
			session modify: record in: [].
			session reset.
			record := session readOneOf: GlorpRecordWithUpdateTime.
			time := record updateTime.
			session reset.
			newRecord := session
				readOneOf: GlorpRecordWithUpdateTime
				where:
					[:each | 
						(each updateTime > (time - 1 second))
						& (each updateTime < (time + 1 second))].
			self assert: newRecord id = record id].