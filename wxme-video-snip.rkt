#lang racket/base
(require racket/class
         racket/format
         wxme
         pict)
   
(provide reader)
   
(define video-reader%
  (class* object% (snip-reader<%>)
    (define/public (read-header version stream) (void))
    (define/public (read-snip text-only? version stream)
      (define color (send stream read-inexact "video-snip"))
      (cond
        [text-only?
         (string->bytes/utf-8 (~s `(list ,color)))]
        [else
         (new video-readable [color color])]))
    (super-new)))
   
(define video-readable
  (class* object% (readable<%>)
    (init-field color) 
    (define/public (read-special source line column position)
      ;; construct a syntax object holding a 3d value that
      ;; is a circle from the pict library with an appropriate
      ;; source location
      (datum->syntax #f
                     (list color)
                     (vector source line column position 1)
                     #f))
    (super-new)))
   
(define reader (new video-reader%))
