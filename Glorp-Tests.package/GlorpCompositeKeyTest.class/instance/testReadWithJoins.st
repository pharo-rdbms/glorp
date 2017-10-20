tests- basic reading
testReadWithJoins
	| users |
	users := session read: GlorpUser where: [:each | each folders anySatisfyJoin: [:eachFolder |
		eachFolder messages anySatisfyJoin: [:eachMessage | eachMessage subject = 'goes in folder 1']]].
	self assert: users size = 1.
	self assert: users first id = 1.