tests- basic reading
testFaulting
	| users user1 sortedFolders user2 |
	users := session read: GlorpUser.
	user1 := users detect: [:each | each id = 1].
	self assert: user1 folders size = 2.
	sortedFolders := user1 folders asSortedCollection: [:a :b | a name < b name].
	self assert: sortedFolders first name = 'One'.
	user2 := users detect: [:each | each id = 2].
	self assert: user2 folders first messages first subject = 'goes in folder 2'.