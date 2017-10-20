testing
hasWidth
	"Return true if this type has a width attribute - basically meaning it's a string or LOB type. Note that this is different from the isVariableWidth test, which tells us if a field has fixed vs. varying width. So a CHAR field hasWidth=>true, but isVariableWidth=>false, while a VARCHAR field hasWidth=>true isVariableWidth=>false, and a NUMBER has both false."
	^false.