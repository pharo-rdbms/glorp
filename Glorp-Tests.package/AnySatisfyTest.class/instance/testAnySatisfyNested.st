running
testAnySatisfyNested
	session readOneOf: ASCustomer
		where: 
			[:cust |
			cust orders anySatisfy: 
					[:order |
					order lineItems
						anySatisfy: [:lineItem | (lineItem item name like: 'os%') & (lineItem quantity > 0)]]]