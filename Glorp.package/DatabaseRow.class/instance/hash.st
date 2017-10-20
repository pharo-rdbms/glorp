testing
hash
	| basic |
	basic := self table hash.
	self fieldsAndValuesDo: 
			[:eachField :eachValue | 
			basic := basic bitXor: eachField hash.
			basic := basic bitXor: eachValue hash].
	^basic.