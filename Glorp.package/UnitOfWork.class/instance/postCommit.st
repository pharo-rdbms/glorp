begin/commit/abort
postCommit
	self sendPostWriteNotification.
	self updateSessionCache.
	self validateRowsPostWrite.