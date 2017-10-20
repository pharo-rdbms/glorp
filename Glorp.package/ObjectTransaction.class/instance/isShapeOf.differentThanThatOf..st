private/restoring
isShapeOf: original differentThanThatOf: copy

	^original class ~~ copy class or: [original glorpBasicSize ~= copy glorpBasicSize]