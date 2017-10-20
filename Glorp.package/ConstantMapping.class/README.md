Sometimes you just want a constant value to be set, either in the row, the object or both. And sometimes you just want a non-mapping (e.g. with a ConditionalMapping where one
of the conditions means "this isn't mapped"). This mapping represents these situations.
It also handles the special case where it's useful to have access to the session inside a
domain object, by allowing you to map it to an instance variable.

So far only the case of mapping to an inst var is implemented.

Instance Variables:
