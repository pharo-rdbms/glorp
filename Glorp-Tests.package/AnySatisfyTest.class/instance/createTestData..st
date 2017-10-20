example data
createTestData: aSession
	| bonus itemBonus |
	aSession inUnitOfWorkDo:
		[| item order lineItem customer |
		customer := aSession readOneOf: ASCustomer where: [:cust | cust id = 5].
		customer ifNil:
			[customer := ASCustomer new id: 5; name: 'Informing AG' yourself.
			aSession register: customer].
		customer orders isEmpty
			ifTrue: 
				[order := ASOrder new orderNo: 10; customer: customer; yourself.
				aSession register: order.
				customer orders add: order]
			ifFalse: [order := customer orders first].
		item := aSession readOneOf: ASItem where: [:itm | itm id = 20].
		item ifNil:
			[item := ASItem new id: 20; name: 'ost'; yourself.
			aSession register: item].
		order lineItems isEmpty ifTrue: 
			[lineItem := ASOrderLineItem new posNo: 30; quantity: 15; price: 25; item: item; order: order; yourself.
			aSession register: lineItem.
			order lineItems add: lineItem].
		bonus := aSession readOneOf: ASBonus where: [:bos | bos id = 27].
		bonus ifNil:
			[bonus := ASBonus new id: 27; name: 'BigTimeSavings'; credits: 100; yourself.
			aSession register: bonus].
		item bonuses isEmpty ifTrue:
			[itemBonus := ASItemBonus new item: item; bonus: bonus; yourself.
			aSession register: itemBonus.
			item bonuses add: itemBonus]].