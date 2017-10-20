accessing
port
	"connect string looks like hostname:portNumber_db-name.
	:portNumber is optional"
	| str portIndex index dbIndex |
	port == nil
		ifFalse: [^ port].
	port == nil
		ifTrue: [str := self connectString.
			portIndex := index := str indexOf: $:.
			dbIndex := str indexOf: $_.
			index = 0
				ifTrue: [index := dbIndex].
			port := portIndex = 0
						ifTrue: [self platform defaultPort asString]
						ifFalse: [(str copyFrom: portIndex + 1 to: dbIndex - 1) asString].
			^ port]