types
float4
	"The only kind of REAL that SQLite supports is an 8-byte IEEE floating point number, so we just map float4 to float8."

	^self double