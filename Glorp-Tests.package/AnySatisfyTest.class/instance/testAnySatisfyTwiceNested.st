running
testAnySatisfyTwiceNested
	session readOneOf: ASCustomer where:
		[:cust |
		cust name = 'Informing AG' AND:
			[cust orders anySatisfy:
				[:order |
				order lineItems anySatisfy:
					[:lineItem |
					lineItem item bonuses anySatisfy:
						[:itemBonus | itemBonus bonus credits > 50]]]]].