support
setUp

	super setUp.
	platform := GlorpDatabaseLoginResource defaultPlatform.
	t1 := DatabaseTable named: 'T1'.
	t2 := DatabaseTable named: 'T2'.
	t3 := DatabaseTable named: 'T3'.
	f1 := t1 createFieldNamed: 'f1' type: (platform varChar: 10).
	f2 := t2 createFieldNamed: 'f2' type: (platform varChar: 10).
	f3 := t3 createFieldNamed: 'f3'  type: (platform varChar: 10).
	rowMap := RowMap new.
	o1 := 'one'.
	o2 := 'two'.
	o3 := 'three'.