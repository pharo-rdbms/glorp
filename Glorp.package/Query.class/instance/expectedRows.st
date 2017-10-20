accessing
expectedRows
	"How many rows do we think it's likely this query will bring back. Used for tweaking things like block factor"
	^expectedRows isNil
		ifTrue: [expectedRows := self readsOneObject ifTrue: [1] ifFalse: [100]]
		ifFalse: [expectedRows]