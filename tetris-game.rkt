;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname tetris-game) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/batch-io)
(require 2htdp/image)
(require 2htdp/universe)
;Tetris
(define WIDTH 10) ; # of blocks, horizontally 
(define SIZE 10) ; blocks are squares
(define SCENE-SIZE (* WIDTH SIZE))
 
 
(define BLOCK ; red squares with black rims
  (overlay
    (square (- SIZE 1) "solid" "red")
    (square SIZE "outline" "black")))

(define-struct tetris [block landscape])
(define-struct block [x y])
 
; A Tetris is a structure:
;   (make-tetris Block Landscape)
; A Landscape is one of: 
; – '() 
; – (cons Block Landscape)
; A Block is a structure:
;   (make-block N N)
 
; interpretations
; (make-block x y) depicts a block whose left 
; corner is (* x SIZE) pixels from the left and
; (* y SIZE) pixels from the top;
; (make-tetris b0 (list b1 b2 ...)) means b0 is the
; dropping block, while b1, b2, and ... are resting

(define tetris-board (empty-scene SCENE-SIZE SCENE-SIZE))
(define (make-block-list len)
  (cond
    [(= 0 len) '()]
    [else (cons BLOCK (make-block-list (- len 1)))]))
;turns a list of blocks into a list of posns
(define (make-block-posns blocks)
  (cond
    [(empty? blocks) '()]
    [else (cons (make-block-posn (first blocks)) (make-block-posns (rest blocks)))]))
;turns a single block into single posn
(define (make-block-posn b)
  (make-posn (* (block-x b) SIZE) (* (block-y b) SIZE)))
;220
(define (render-tetris tetrisCurr)
  (place-images/align
   (make-block-list (+ (length (tetris-landscape tetrisCurr)) 1))
   (cons (make-block-posn (tetris-block tetrisCurr)) (make-block-posns (tetris-landscape tetrisCurr)))
   "left" "top" tetris-board))
;221
;(define-struct tetris [block landscape])
(define (tock-tetris ws)
  (cond
    [(equal? (set-block? ws) #true) (make-tetris (generate-new-block (tetris-block ws)) (cons (tetris-block ws) (tetris-landscape ws)))]
    [else (make-tetris (increment-block (tetris-block ws)) (tetris-landscape ws))]))

(define (set-block? ws)
  (or
   (member? (increment-block (tetris-block ws)) (tetris-landscape ws))
   (> (block-y (tetris-block ws)) (- SIZE 2)))) ;minus 1 for top left alignment, minus 1 more for needing to catch it a brick early like above
  

;block should be at y = 0, x = prev + 1. if prev_x is max right value + 1, x = 0
(define (generate-new-block prev)
  (make-block
   (cond
     [(= (- WIDTH 1) (block-x prev)) 0]
     [else (+ (block-x prev) 1)])
   0))
;increments block 1 in y direction from previous
(define (increment-block prev)
  (make-block
   (block-x prev)
   (+ (block-y prev) 1)))

(define (handle-keys-tetris ws ke)
  (make-tetris 
   (cond
     [(string=? ke "left") (handle-left (tetris-block ws) (tetris-landscape ws))]
     [(string=? ke "right") (handle-right (tetris-block ws) (tetris-landscape ws))]
     [else (tetris-block ws)])
   (tetris-landscape ws)))
(define (handle-left prev ls)
  (cond
    [(or
      (= 0 (block-x prev)) ;next to wall
      (member? (make-block (- (block-x prev) 1) (block-y prev)) ls)) prev] ;next to another piece
    [else (make-block (- (block-x prev) 1) (block-y prev))]))
(define (handle-right prev ls)
  (cond
    [(or
      (= (- WIDTH 1) (block-x prev)) ;next to wall
      (member? (make-block (+ (block-x prev) 1) (block-y prev)) ls)) prev];next to another piece
    [else (make-block (+ (block-x prev) 1) (block-y prev))]))

(define (tetris-overflow ws)
  (contains-zero-y (tetris-landscape ws)))

;ls = landscape
;returns true when the landscape contains a 0 y coordinate
(define (contains-zero-y ls)
  (cond
    [(empty? ls) #false]
    [(= (block-y (first ls)) 0) #true]
    [else (contains-zero-y (rest ls))]))
;removes the first item from the landscape and puts it into the block piece of the data structure so an extra block isn't added to the final render
(define (tetris-render-final ws)
  (render-tetris (make-tetris (first (tetris-landscape ws)) (rest (tetris-landscape ws)))))

(define (main-tetris ws fps)
  (big-bang ws
    [on-tick tock-tetris fps]
    [on-key handle-keys-tetris]
    [to-draw render-tetris]
    [stop-when tetris-overflow tetris-render-final]
    ))

(main-tetris (make-tetris (make-block 0 0) '()) .05)