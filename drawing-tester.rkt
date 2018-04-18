#lang racket

(require racket/gui)

(provide test-drawing
         image->bitmap)

(define (test-drawing f)
  (define frame (new frame%
                     [label "Example"]
                     [width 300]
                     [height 300]))

  (new canvas% [parent frame]
       [paint-callback
        (lambda (canvas dc)
          (f dc))])

  (send frame show #t))


(require racket/class
         (only-in racket/draw make-bitmap bitmap-dc%)
         (only-in 2htdp/image image-width image-height)
         (only-in mrlib/image-core render-image))

(define (image->bitmap image dc)
  (let* ([width (image-width image)]
         [height (image-height image)]
         [bm (make-bitmap width height)])
    (render-image image dc 0 0)))
