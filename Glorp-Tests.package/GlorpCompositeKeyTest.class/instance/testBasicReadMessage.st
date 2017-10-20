tests- basic reading
testBasicReadMessage
	| messages |
	messages := (session read: GlorpMessage) asSortedCollection: [:a :b | a subject <= b subject].
	self assert: messages size = 3.
	self assert: messages first subject = 'also goes in folder 1'.
	self assert: (messages at: 2) subject = 'goes in folder 1'.
	self assert: messages last subject = 'goes in folder 2'.