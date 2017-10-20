reaping
restartIfNecessary
	[mutex wait.
	done
		ifTrue:
			["Transcript cr; show: 'Restarting', (Time millisecondClockValue // 1000) printString."
			done := false.
			self forkReaperThread]] ensure: [mutex signal].