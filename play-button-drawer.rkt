#lang racket

(require 2htdp/image)

(provide play-button)

(define (play-button color)
  (overlay/offset
   (rotate
    -90
    (triangle 20 "solid" "white"))
   -2 0
   (circle 20 "solid" color)))

(module+ test
  (require "./drawing-tester.rkt")
  (test-drawing (curry image->bitmap (play-button "red"))))


