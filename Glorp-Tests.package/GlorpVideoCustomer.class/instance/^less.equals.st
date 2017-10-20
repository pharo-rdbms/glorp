comparing
<= aVideoCustomer
	^self name < aVideoCustomer name
	or: [self name = aVideoCustomer name
		and: [self dateOfBirth <= aVideoCustomer dateOfBirth]]