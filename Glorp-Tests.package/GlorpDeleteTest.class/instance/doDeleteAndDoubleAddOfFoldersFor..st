tests
doDeleteAndDoubleAddOfFoldersFor: user
	| new2 removed new |
	^session
		modify: user
		in:
			[user folders do: [:each | each printString].
			removed := user folders detect: [:each | each name = 'One'].
			user folders remove: removed.
			new := GlorpFolder new name: 'One'.
			new user: user.
			user folders add: new.
			new2 := GlorpFolder new name: 'One'.
			new2 user: user.
			user folders add: new2].