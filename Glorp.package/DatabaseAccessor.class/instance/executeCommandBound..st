executing
executeCommandBound: command
	"By default, we don't handle binding"
	^command executeUnboundIn: self.