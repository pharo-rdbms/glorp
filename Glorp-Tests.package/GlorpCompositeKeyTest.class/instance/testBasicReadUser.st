tests- basic reading
testBasicReadUser
	| users |
	users := (session read: GlorpUser) asSortedCollection: [:a :b | a id <= b id].
	self assert: users size = 2.
	self assert: users first name = 'User One'.
	self assert: users last name = 'User Two'.