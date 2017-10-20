accessing
host
	"connect string looks like hostname:portNumber_db-name.
	:portNumber is optional"
	| str portIndex index dbIndex |
	host == nil
		ifFalse: [^ host].
	host == nil
		ifTrue: [str := self connectString.
			portIndex := index := str indexOf: $:.
			dbIndex := str indexOf: $_.
			index = 0 ifTrue: [index := dbIndex].
			host := index > 0
				ifTrue: [ str copyFrom: 1 to: index - 1 ].
			^ host]