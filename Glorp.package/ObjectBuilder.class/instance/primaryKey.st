accessing
primaryKey
	"We use self as a special guard value to indicate that the value hasn't changed"
	key == self ifFalse: [^key].
	self canCache ifFalse: [^nil].
	key := self descriptor keyFields
		collect: [:each | self valueOfField: each].
	key size = 1 ifTrue: [key := key first].
	^key.