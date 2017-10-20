This is a mapping that does different things depending on some testable condition. Depending on whether we're reading or writing, we are likely to test different things. This is useful if a field can be interpreted in more than one way. The API is rather messy.

Instance Variables:
	cases	<SequenceableCollection of: (Association)>	Used on read - a list of associations representing the cases we test. The key is either a one-argument block to be evaluated or a one-argument selector to be performed by the descriptorSystem, returning a boolean, and the value is the mapping to use if it returns true. 
	conditionalField	<DatabaseField>	The field whose value will be used as the argument to the blocks/selectors in cases.
	otherwiseCase	<Mapping>	If none of the other cases evaluate to true on read, use this mapping.

	conditionalMethod	<Block | Symbol>	Used on write - a zero-argument selector or one-argument block. The selector will be sent to the object being written, the block will be evaluated with that object as the argument. This is expected to return the object that will be written via the appropriate mapping.
	conditionalFieldMapping	<Mapping>	Used on write - the mapping used to write out the value in the conditional field.

