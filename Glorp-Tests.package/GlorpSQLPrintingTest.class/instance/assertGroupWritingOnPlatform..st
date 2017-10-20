utilities
assertGroupWritingOnPlatform: platform
	| system row1 row2 command string session |
	session := GlorpDemoDescriptorSystem sessionForLogin: (Login new database: platform).
	system := session system.
	row1 := DatabaseRow newForTable: (system tableNamed: 'GR_ADDRESS').
	row1 atFieldNamed: 'ID' put: 1.
	row2 := DatabaseRow newForTable: (system tableNamed: 'GR_ADDRESS').
	row2 atFieldNamed: 'ID' put: 2.
	command := InsertCommand forRows: (Array with: row1 with: row2) useBinding: false session: session.
	string := command sqlString.
	self assert: (string includes: $;).
	self assert: string = 'INSERT INTO GR_ADDRESS (ID,STREET,HOUSE_NUM)  VALUES (1,NULL,NULL); INSERT INTO GR_ADDRESS (ID,STREET,HOUSE_NUM)  VALUES (2,NULL,NULL)'.