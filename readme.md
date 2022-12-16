# cvf

cvf is a DSL for text formatting, written in forth. by default, each line of input is echoed to output, followed by a newline. this leads to very simple quines.

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
    '\n' EMIT
;
#
```

this defines a horizontal rule word.

the stack and dictionary persist between forth sections (obviously).

## usage

just pipe the forth file, followed by the cvf document, into your forth implementation of choice. i use jonesforth, but it should work with pretty much anything.

i recommend writing a quick shell script to save writing `cat cvf.f document.cvf | forth` all the time.

## limitations

if you finish a forth section with `#` and immediately have a newline, cvf will not print a newline. however, if you have a space and then a newline, cvf *will* print a newline. this is due to how forth parses the input stream. it's probably fixable, but it would complicate the logic a lot.

the default line buffer is 1024 bytes. if for some reason you have individual lines greater than 1024 bytes, you can `ALLOT` a bigger buffer and do some patching (try `SEE linebuf`).

behaviour on EOF is dependent on the implementation of `KEY`. i recommend terminating input files with an LF, just to be sure.

## compatibility

cvf should be able to run on a pretty basic forth. it's designed for jonesforth, hence it uses `[COMPILE]` instead of `POSTPONE`. with that in mind, it should theoretically run on stuff like pijFORTHos or flashforth. maybe even a jupiter ace, if you're insane. useful for you permacomputing nerds out there.

the forth code embedded in documents can use everything available on your preferred implementation of forth.

## base words

cvf defines a few extra forth words that might be useful. see the examples directory for usage examples.

### cvf control words

cvf defines a few words and variables used for control of the formatter.

| word | stack | description |
| --- | --- | --- |
| `slb` | ( -- ) | switch to soft line breaks |
| `hlb` | ( -- ) | switch to hard line breaks, and print a line feed (\n) |
| `emitl` | ( addr len -- ) | print a line of text, wrapping it to the current width |
| `linebuf` | ( -- buf* ) | push the address of the input buffer to the stack |

| variable | description |
| --- | --- |
| `width` | contains the width (in characters) of the output. used for output wrapping |
| `cur_width` | contains the current line width, when in soft line break mode |

### general words

| word | stack | description |
| --- | --- | --- |
| `[CHAR]` | ( -- ) | compile a literal of the first character of the next word |
| `line` | ( -- addr len ) | get the next line of input |

yes, `[CHAR]` is usually considered standard but jonesforth doesn't have it, and jonesforth is my reference for minimal forth.

## philosophy

it's not often that documentation has a philosophy section, is it?

cvf stands for cosmic.voyage formatter, and it's pretty much designed for me and me alone. i mostly designed it following the principles laid out in charles moore's [programming a problem-oriented language](https://colorforth.github.io/POL.htm) (which you can read for free right now), particularly the Basic Principle (keep it simple).

at first, i used jonesforth because it's just what i had on my machine. after a few hours of work i had a quick look at the forth specification and thought "wow, these people are getting forth completely wrong". the point of forth is that you only define what you need. that's forth's Entire Thing. and sure, it's nice to not have to write your own standard library and have a consistent base to build off of but that's not what forth is for. i started with an extremely minimal wordset and basically wrote everything myself. `line` is based on `KEY`, `emitl` just frobs the pointer and length values. i wrote what i needed to and not a word more.
