begin/commit/abort
validateRowsPostWrite
	"Perform basic validation after writing is done. It's better to validate beforehand, but some things are easier to catch afterwards"
	
	self system validateRowsPostWrite: self.