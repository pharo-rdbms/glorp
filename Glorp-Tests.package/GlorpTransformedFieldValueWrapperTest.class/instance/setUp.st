support
setUp
	super setUp.
	inner := FieldValueWrapper new.
	outer := TransformingFieldValueWrapper new innerWrapper: inner; forwardTransformation: [:a | a * 2]; inverseTransformation: [:a | a / 2].