tests- basic reading
testBasicReadFolder
	| folders |
	folders := (session read: GlorpFolder) asSortedCollection: [:a :b | a name <= b name].
	self assert: folders size = 3.
	self assert: folders first name = 'One'.
	self assert: folders last name = 'Two'.