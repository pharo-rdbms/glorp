login
connectionArgsFromCurrentLogin

	"connect string looks like  hostname:portNumber_db-name. :portNumber is optional"
	| str portIndex index dbIndex |
	str := self currentLogin connectString.
	portIndex := index := str indexOf: $:.
	dbIndex := str indexOf: $_.
	index = 0 ifTrue: [index := dbIndex].
	^(Dialect smalltalkAt: #PGConnectionArgs)
		hostname: (str copyFrom: 1 to: index - 1)
		portno: (portIndex = 0 ifTrue: [5432] ifFalse: [(str copyFrom: portIndex + 1 to: dbIndex - 1) asNumber])
		databaseName: (str copyFrom: dbIndex + 1 to: str size)
		userName: self currentLogin username
		password: self currentLogin password