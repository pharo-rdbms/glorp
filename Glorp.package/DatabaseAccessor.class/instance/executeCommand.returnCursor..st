executing
executeCommand: command returnCursor: aBoolean
	^mutex
		critical:
			[| result |
			self checkPermissionFor: command.
			result := [(self useBinding and: [command useBinding])
				ifTrue: [command executeBoundIn: self]
				ifFalse: [command executeUnboundIn: self]]
				on: Dialect error
				do: [:ex | self handleError: ex for: command].
			aBoolean ifTrue: [result] ifFalse: [result upToEnd]].