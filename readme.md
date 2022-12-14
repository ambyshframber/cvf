# cvf

cvf is a DSL for text formatting, written in forth. by default, each line of input is echoed to output, followed by a newline.

you can exit back into forth by starting a line with `~`, and go back into echo mode with `#`.

```forth
here's some text
more text
~ ." here's some forth!" '\n' EMIT #
and now we're doing regular text again
```

you can do anything you like inside the forth sections. they can span multiple lines if you want!

```forth
~
: hr ( n -- )
    [CHAR] =
    BEGIN OVER WHILE
        SWAP 1- SWAP DUP EMIT
    REPEAT
    2DROP
;
#
```

this defines a horizontal rule word.

the stack and dictionary persist between forth sections (obviously).

## usage

just pipe the forth file, followed by the cvf document, into your forth implementation of choice. i use jonesforth, but it should work with pretty much anything.

i recommend writing a quick shell script to save writing `cat cvf.f document.cvf | forth` all the time.

## base words

cvf defines a few extra forth words that might be useful. see the examples directory for usage examples.

### cvf control words

| word | stack | description |
| --- | --- | --- |
| `slb` | ( -- ) | switch to soft line breaks |
| `hlb` | ( -- ) | switch to hard line breaks, and print a line feed (\n) |

### general words

| word | stack | description |
| --- | --- | --- |
| `[CHAR]` | ( -- ) | compile a literal of the first character of the next word |
