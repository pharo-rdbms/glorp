tables
tableForMONEY_IMAGINARY_TABLE: aTable

	aTable isImaginary: true.
	aTable createFieldNamed: 'CURRENCY' type: (platform varChar: 5).
	aTable createFieldNamed: 'AMOUNT' type: platform int4