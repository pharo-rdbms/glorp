support
setUp

	| stub |
	super setUp.
	session := GlorpSessionResource current newSession.
	proxy := Proxy new.
	proxy session: session.
	stub := GlorpQueryStub readOneOf: GlorpAddress where: [:address | address id = 1].
	stub result: 42.
	proxy query: stub.
	proxy parameters: #().