reaping
forkReaperThread

	| block |
	block := [
		[done] whileFalse: [
			(Delay forSeconds: self delay) wait.
			self reapExpiredObjects]].
	reaperThread := block forkAt: Processor userBackgroundPriority