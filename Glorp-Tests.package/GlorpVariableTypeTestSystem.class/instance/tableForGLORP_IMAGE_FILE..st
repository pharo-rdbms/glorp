classes
tableForGLORP_IMAGE_FILE: aTable
	aTable createFieldNamed: 'ID' type: platform serial.
	aTable createFieldNamed: 'TITLE' type: platform text.
	aTable createFieldNamed: 'BITS' type: platform blob.
	aTable createFieldNamed: 'THUMBNAIL_BITS' type: platform blob.