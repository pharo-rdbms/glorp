tests
verifyEncyclopedias: readBackEncyclopedias
	| plagiarists canadian |
	self assert: readBackEncyclopedias size = 3.
	canadian := readBackEncyclopedias first.
	self assert: canadian name = 'The Canadian Encyclopedia'.
	self assert: canadian entries size = 3.
	self assert: (canadian entries at: 'abcde') id = 'two'.
	self assert: (canadian entries at: '12345') id = 'one'.
	self assert: (canadian entries at: 'unique') id = 'three'.
	plagiarists := readBackEncyclopedias at: 2.
	self assert: plagiarists entries size = 2.
	self
		assert:
			(plagiarists entries at: '54321') = (canadian entries at: '12345').
	self
		assert:
			(plagiarists entries at: 'edcba') = (canadian entries at: 'abcde').
	self assert: readBackEncyclopedias last entries isEmpty.