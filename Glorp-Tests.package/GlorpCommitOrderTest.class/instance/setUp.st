support
setUp

	super setUp.
	platform := system platform.
	t1 := DatabaseTable new name: 'T1'.
	t1id := (t1 createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	t2 := DatabaseTable new name: 'T2'.
	t2id := (t2 createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	t3 := DatabaseTable new name: 'T3'.
	t3id := (t3 createFieldNamed: 'ID' type: platform int4) bePrimaryKey.