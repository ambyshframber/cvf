1024 ALLOT CONSTANT linebuf
VARIABLE soft_linebreaks
FALSE soft_linebreaks !
: [CHAR] IMMEDIATE [COMPILE] CHAR [COMPILE] LITERAL ;

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

: #
    BEGIN linebuf line OVER WHILE
        TELL 
        soft_linebreaks @ IF BL ELSE '\n' THEN EMIT 
    REPEAT
    KEY DROP \ get rid of ~ (idk why this is needed but it is)
    2DROP
;

: slb TRUE soft_linebreaks ! ;
: hlb FALSE soft_linebreaks ! '\n' EMIT ;


#
