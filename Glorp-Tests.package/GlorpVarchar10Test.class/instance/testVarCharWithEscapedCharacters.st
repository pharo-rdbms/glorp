tests
testVarCharWithEscapedCharacters
	stType := String.
	self helpTestValue: nil.
	#($\ $~ $` $! $@ $# $$ $% $^ $& $* $( $) $_ $- $+ $= $| $} ${ $] $[ $" $' $: $; $? $/ $> $. $< $,)
		do: [:ea | self helpTestValue: 'abc' , (String with: ea) , 'def']