accessing
databaseName
	"connect string looks like hostname:portNumber_db-name.
	:portNumber is optional"
	
	| str portIndex index dbIndex |
	
	databaseName == nil
		ifFalse: [^ databaseName].
	databaseName == nil
		ifTrue: [str := self connectString.
			portIndex := index := str indexOf: $:.
			dbIndex := str indexOf: $_.
			index = 0
				ifTrue: [index := dbIndex].
			databaseName := str copyFrom: dbIndex + 1 to: str size.
			^ databaseName]