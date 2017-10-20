executing
connection
	self databaseDriver ifNil: [ ^nil ].
	^self databaseDriver connection