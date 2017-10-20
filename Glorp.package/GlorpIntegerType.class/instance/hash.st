comparing
hash
	"Our hash must be identical to GlorpNumericType's hash when it is an #isInteger"
	^self platform hash bitXor: self impliedSmalltalkType hash