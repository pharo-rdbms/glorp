tests
testHashedCollection
	| object originalMembers |
	object := Set new.
	originalMembers := #(#one #two #three 'four' 5 'vi' (1 2 3 4 5 6 7)) collect: [:each | each copy].
	object addAll: originalMembers.
	transaction begin.
	transaction register: object.
	object remove: #one; remove: (originalMembers at: 4).
	object add: 1.
	originalMembers last at: 7 put: 'seven'.
	transaction abort.
	self
		assert: object size = originalMembers size;
		assert: (object includes: originalMembers first);
		assert: (object includes: (originalMembers at: 4));
		assert: object size = (object rehash; size).
	originalMembers do: [:each | self assert: (object includes: each)]