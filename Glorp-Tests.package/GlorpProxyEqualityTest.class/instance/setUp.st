initialize-release
setUp 

	super setUp. 
	session := GlorpSessionResource current newSession.
	proxy := Proxy new.
	proxy session: session.
	stub := GlorpQueryStub readOneOf: GlorpAddress where: [:address | address id = 1].
	stub result: 'abc'.
	proxy query: stub.
	proxy parameters: #().
	proxy2 := Proxy new.
	proxy2 session: session.
	stub2 := GlorpQueryStub readOneOf: GlorpAddress where: [:address | address id = 1].
	stub2 result: 'abc'.
	proxy2 query: stub2.
	proxy2 parameters: #().