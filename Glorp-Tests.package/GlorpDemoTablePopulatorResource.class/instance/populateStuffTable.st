setup
populateStuffTable
 
	login accessor executeSQLStringNoResult: 'INSERT INTO STUFF VALUES (12,''abc'')'.
	login accessor executeSQLStringNoResult: 'INSERT INTO STUFF VALUES (13, ''hey nonny nonny'')'.
	login accessor executeSQLStringNoResult: 'INSERT INTO STUFF VALUES (42, ''yabba dabba doo'')'.
	login accessor executeSQLStringNoResult: 'INSERT INTO STUFF VALUES (9625, ''the band played on'')'.
	login accessor executeSQLStringNoResult: 'INSERT INTO STUFF VALUES (113141, ''Smalltalk'')'.