classes
tableForGALLERY_LINK: aTable
	| galleryId imageId |
	galleryId := aTable createFieldNamed: 'GALLERY_ID' type: platform integer.
	aTable addForeignKeyFrom: galleryId to: ((self tableNamed: 'GALLERY') fieldNamed: 'ID').
	imageId := aTable createFieldNamed: 'IMAGE_ID' type: platform integer.
	aTable addForeignKeyFrom: imageId to: ((self tableNamed: 'GLORP_IMAGE_FILE') fieldNamed: 'ID').
	"Avoid booleans here because they aren't portable"
	aTable createFieldNamed: 'LARGE' type: (platform char: 1).