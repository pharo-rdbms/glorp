api
constructRowMapKeyAs: aBlock
	"Give us the opportunity to construct a custom row map key. This is useful if you need to force two relationships to share a link table entry"
	rowMapKeyConstructorBlock := aBlock.