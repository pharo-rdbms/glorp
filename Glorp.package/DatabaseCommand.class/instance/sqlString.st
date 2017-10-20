accessing
sqlString
	sqlString isNil ifTrue: [
		stream isNil ifTrue: [stream := WriteStream on: (String new: 100)].
		self printSQL.
		sqlString := stream contents.
		stream := nil].
	^sqlString.