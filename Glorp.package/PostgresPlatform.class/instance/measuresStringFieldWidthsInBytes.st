testing
measuresStringFieldWidthsInBytes
	"Return true if we measure the width of a string in bytes rather than characters. So, a 255-character field can hold 255 bytes worth of string, not 255 characters. This is important with encodings"
	^true.