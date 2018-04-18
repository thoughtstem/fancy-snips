#lang racket

(require video-snip)

(define v (new video-snip% [msg "TETS"]))

(set-field! msg v "HELLO" )

(get-field msg v)

v
