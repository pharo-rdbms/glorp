private
deferentialSetSchema: newTable
	"If the table already has a schema, do not overwrite it.  Avoiding an ill-constructed login setting a schema to nil.  (DatabaseTable initializes schema to the empty string, not nil, although its code allows for nil schemas so making this convenient rather than essential)."

	| temp |
	newTable schema isEmpty ifFalse: [^self].
	(temp := self session) isNil ifTrue: [^self].
	(temp := temp accessor) isNil ifTrue: [^self].
	(temp := temp currentLogin) isNil ifTrue: [^self].
	(temp := temp schema) isNil ifTrue: [^self].
	newTable schema: temp.