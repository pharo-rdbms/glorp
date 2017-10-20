general portability
quitTheImage
	"Quit the entire image"

	^(self smalltalkAt: #SmalltalkImage) current snapshot: false andQuit: true