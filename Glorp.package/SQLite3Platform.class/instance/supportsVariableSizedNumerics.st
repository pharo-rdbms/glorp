constants
supportsVariableSizedNumerics
	"SQLite supports a single 8-byte IEEE floating point type:  e.g. give it 321.12s and it will return 321.12d.  Perhaps clever Glorp converters could arrange for Glorp to know which fields are really FixedPoint numbers, as we do for Date, Time and Timestamp (which SQLite also does not support) but I'll leave that until there's demand for it (ee also #canBind:to:)."

	^false