This is an attempt to allow a cast to be used on constants, as e.g.
   CAST value: '1-2-3' as: platform date
It doesn't work yet, since printing of constants doesn't like having functions in the way - it conflicts with type conversion, and looks like it'll take a bit of work to fix.