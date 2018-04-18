#lang racket/base

(require racket/class
         racket/snip
         racket/format
         racket/gui
         "./drawing-tester.rkt"
         "./play-button-drawer.rkt"
         "./video-frame-demo.rkt")
 
(provide video-snip%
         (rename-out [video-snip-class snip-class]))
 
(define video-snip%
  (class snip%
    (inherit set-snipclass
             get-flags set-flags
             get-admin)

    (init-field [msg "Hello world"])
    (init-field [size 40])
    (init-field [animation-frame 0])
    (init-field [animation (list (play-button "pink")
                                 (play-button "red")
                                 (play-button "darkred")
                                 (play-button "red"))])


    (init-field [frame  (video-frame-demo)])

    (init-field [icon-thread (thread
                              (λ ()
                                (let loop ()
                                  (update-animation)
                                  (loop))))])
    

    
    (super-new)
    
    (set-snipclass video-snip-class)
    (send (get-the-snip-class-list) add video-snip-class)
    (set-flags (cons 'handles-events (get-flags)))

    
    (define (update-animation)
      (set! animation-frame
            (modulo (add1 animation-frame)
                    (length animation)))
      (refresh)
      (sleep (/ 1 5)))

    (define/public (refresh)
      (queue-callback
       (λ ()
         (define admin (send this get-admin))
         (when admin
           (send admin needs-update this 0 0 size size)))))

    (define/override (get-extent dc x y                                
                                 [w #f]
                                 [h #f]
                                 [descent #f]
                                 [space #f]
                                 [lspace #f]
                                 [rspace #f])
      (define (maybe-set-box! b v) (when b (set-box! b v)))
      (maybe-set-box! w (+ 2.0 size))
      (maybe-set-box! h (+ 2.0 size))
      (maybe-set-box! descent 1.0)
      (maybe-set-box! space 1.0)
      (maybe-set-box! lspace 1.0)
      (maybe-set-box! rspace 1.0))
    
    (define/override (draw dc x y left top right bottom dx dy draw-caret)
      (send dc translate x y)
      (image->bitmap (list-ref animation animation-frame) dc)
      (send dc translate (- x) (- y)))
    
    (define/override (copy)
      (new video-snip%))
    
    (define/override (write f)
      ;For some reason, removing this weird put line causes an error
      ;  read-bytes: WXME format problem while reading for header/footer extension count
      ;  (expected exact integer between [-2^31,2^31]) from port: #<input-port:string> around position: 8936 
      ;Nothing special about 20, btw.  Any number fine.
      (send f put 20))

    (define (show-picker)
      (send frame show #t))
    
    (define/override (on-event dc x y editorx editory e)
      (when (send e button-down?)
        (show-picker)
        
        (define admin (get-admin))
        (when admin
          (send admin resized this #t))))))
 
(define video-snip-class%
  (class snip-class%
    (inherit set-classname)
    
    (super-new)
    (set-classname (~s '((lib "main.rkt" "video-snip")
                         (lib "wxme-video-snip.rkt" "video-snip"))))
    
    (define/override (read f)
      (new video-snip%))))
 
(define video-snip-class (new video-snip-class%))



