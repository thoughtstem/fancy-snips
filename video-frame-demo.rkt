#lang racket

(provide video-frame-demo)

(require racket/gui
         (prefix-in h: 2htdp/image)
         "./drawing-tester.rkt")

(define (path->image p f)
  (h:bitmap/file (string-append p "/" (path->string f))))

(define (path->images p)
  (map (curry path->image p)
       (directory-list p)))

(define (video-frame-demo)
  (define i 0)
  #;(define imgs (list (h:circle 20 "solid" "red")
                     (h:circle 40 "solid" "red")
                     (h:circle 80 "solid" "red")))

  (define imgs (path->images "/Users/thoughtstem/Dev/snip-experiments/video-snip/demo-pngs/RainbowSmall2"))
  
  (define frame (new frame%
                     [label  "Example"]
                     [width  300]
                     [height 300]))
  
  (define canvas (new canvas% [parent frame]
                         [paint-callback
                          (lambda (canvas dc)
                            (image->bitmap (list-ref imgs i) dc))]))
  
  (define canvas-thread (thread
                         (λ ()
                           (let loop ()
                             (send canvas refresh)
                             (set! i (remainder (add1 i)
                                                (length imgs)))
                             (sleep 1/20)
                             (loop)))))

  frame)

(send (video-frame-demo) show #t)
