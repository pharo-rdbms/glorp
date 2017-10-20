tests- basic reading
testReadWithSubselect
	| users |
	users := session read: GlorpUser where: [:each | each folders anySatisfyExists: [:eachFolder |
		eachFolder messages anySatisfyExists: [:eachMessage | eachMessage subject = 'goes in folder 1']]].
	self assert: users size = 1.
	self assert: users first id = 1.