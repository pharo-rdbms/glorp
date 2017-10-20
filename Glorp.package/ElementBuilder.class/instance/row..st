accessing
row: anArray
	"Since nil is a possible key value, use self as a special marker to indicate we haven't found the key yet"
	row == anArray ifFalse: [
		key := self].
	row := anArray