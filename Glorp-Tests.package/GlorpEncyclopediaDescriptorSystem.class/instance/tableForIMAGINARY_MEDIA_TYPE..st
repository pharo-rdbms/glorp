tables
tableForIMAGINARY_MEDIA_TYPE: aTable 
	aTable isImaginary: true.
  
	aTable createFieldNamed: 'MEDIA_TYPE_NAME' type: (platform varChar: 100).
	aTable createFieldNamed: 'MEDIA_TYPE_MIME' type: (platform varChar: 100).