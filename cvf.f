VARIABLE soft_linebreaks
FALSE soft_linebreaks !

VARIABLE width
80 width !

1024 ALLOT CONSTANT linebuf

: [CHAR] IMMEDIATE CHAR [COMPILE] LITERAL ;

: line ( buf -- addr len | 0 0 )
\ 0 0 iff line starts with '~'
    DUP

    KEY DUP [CHAR] ~ = IF
        2DROP DROP 0 0 EXIT
    THEN 
    
    BEGIN DUP '\n' <> WHILE
        \DUP EMIT
        OVER ! 1+ ( addr char -- addr+1 )
        
        KEY \ get key for next go round
    REPEAT

    DROP \ drop newline
    OVER -
;

: wfbuf ( addr0 len0 -- addr1 len1 )
    2DUP OVER + SWAP ( start len end start )
    
    BEGIN DUP @ BL = WHILE
        2DUP <> AND IF 2DROP EXIT THEN
        1+ 
    REPEAT \ find a space
    BEGIN DUP @ BL <> WHILE
        2DUP <> AND IF 2DROP EXIT THEN
        1+
    REPEAT \ find a not space

    1- OVER -
;

: ltrim ( addr len -- addr len )
    2DUP + ( start len end )
    ROT
    ( len end start )
    BEGIN 2DUP > WHILE
        DUP C@ BL <> IF
            -ROT DROP EXIT
        THEN
        1+
    REPEAT
    -ROT DROP EXIT
;

VARIABLE cur_width
0 cur_width !

: emitl ( addr len -- )

    BEGIN ( addr len )
        width @ 2DUP ( addr len width len width )
        SWAP cur_width @ + ( addr len width width len+cur_width )
        >= IF \ if width >= len + cur_width
            DROP
            DUP cur_width +!
            TELL EXIT
        THEN

        \ lazy impl first:
        \ take the first width - cur_width characters of the line and TELL them
        \ emit an LF
        \ set cur_width to 0
        \ loop

        cur_width @ - ( addr len rem_len )
        ROT 2DUP SWAP TELL
        '\n' EMIT
        0 cur_width !

        ( len rem_len addr )
        OVER + ( len rem_len new_addr )
        -ROT -
        ltrim
    AGAIN
;

: #
    BEGIN linebuf line OVER WHILE
        emitl
        soft_linebreaks @ IF
            1 cur_width +! BL
        ELSE
            0 cur_width ! '\n'
        THEN EMIT 
    REPEAT
    KEY DROP \ get rid of ~ (idk why this is needed but it is)
    2DROP
;

: slb TRUE soft_linebreaks ! ;
: hlb FALSE soft_linebreaks ! '\n' EMIT ;


#
