;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname worm-game) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/batch-io)
(require 2htdp/image)
(require 2htdp/universe)
(define WORM-RADIUS 3)
(define WORM-CIRCUMFERENCE (* 2 WORM-RADIUS))
(define GAME-BOARD-UNITS 50)
(define WORM-UNIT (circle WORM-RADIUS "solid" "red"))
(define FOOD (circle WORM-RADIUS "solid" "green"))
(define GAME-BOARD (empty-scene (* WORM-RADIUS GAME-BOARD-UNITS) (* WORM-RADIUS GAME-BOARD-UNITS)))
(define-struct worm-game [w-dir worm-posns food-posn])
(define (increment-head dir front)
  (cond
    [(string=? dir "up") (make-posn (posn-x front) (- (posn-y front) WORM-CIRCUMFERENCE))]
    [(string=? dir "down") (make-posn (posn-x front) (+ (posn-y front) WORM-CIRCUMFERENCE))]
    [(string=? dir "left") (make-posn (- (posn-x front) WORM-CIRCUMFERENCE) (posn-y front))]
    [(string=? dir "right") (make-posn (+ (posn-x front) WORM-CIRCUMFERENCE) (posn-y front))]))
(define (remove-last wl)
  (cond
    [(empty? (rest wl)) '()]
    [else (cons (first wl) (remove-last (rest wl)))]))
(define (food-check-create p candidate)
  (if (or (equal? p candidate) (= (posn-x candidate) 0) (= (posn-y candidate) 0)) (food-create p) candidate))
;makes food in a new position from given p
(define (food-create p)
  (food-check-create
     p (make-posn (*
                   (random (- (/ (image-width GAME-BOARD) WORM-CIRCUMFERENCE) WORM-CIRCUMFERENCE)) WORM-CIRCUMFERENCE)
                  (*
                   (random (- (/ (image-height GAME-BOARD) WORM-CIRCUMFERENCE) WORM-CIRCUMFERENCE)) WORM-CIRCUMFERENCE))))
(define (posn=? p1 p2)
  (and (= (posn-x p1) (posn-x p2)) (= (posn-y p1) (posn-y p2))))
(define (food-collision? wg)
  (posn=? (first (worm-game-worm-posns wg)) (worm-game-food-posn wg)))
(define (eat-food wg)
  (make-worm-game
   (worm-game-w-dir wg)
   (cons (increment-head (worm-game-w-dir wg) (first (worm-game-worm-posns wg))) (worm-game-worm-posns wg))
   (food-create (worm-game-food-posn wg))))
(define (increment-worm wg)
  (make-worm-game
   (worm-game-w-dir wg)
   (cons (increment-head (worm-game-w-dir wg) (first (worm-game-worm-posns wg))) (remove-last (worm-game-worm-posns wg)))
   (worm-game-food-posn wg)))
(define (tock-wg-full wg)
  (cond
    [(food-collision? wg) (eat-food wg)]
    [else (increment-worm wg)]))
(define (render-wg-full wg)
  (place-image FOOD (posn-x (worm-game-food-posn wg)) (posn-y (worm-game-food-posn wg)) (place-images (make-image-list (worm-game-worm-posns wg)) (worm-game-worm-posns wg) GAME-BOARD)))
(define (make-image-list lop)
  (cond
    [(empty? lop) '()]
    [else (cons WORM-UNIT (make-image-list (rest lop)))]))
(define (handle-keys-wg-full wg ke)
  (cond
    [(or (string=? ke "up") (string=? ke "down") (string=? ke "left") (string=? ke "right")) (make-worm-game ke (worm-game-worm-posns wg) (worm-game-food-posn wg))]
    [else wg]))

(define (collision wg)
  (or (self-collision wg) (border-collision wg)))

(define (self-collision wg)
  (cond
    [(= (length (worm-game-worm-posns wg)) 2) (posn=? (first (worm-game-worm-posns wg)) (first (rest (worm-game-worm-posns wg))))]
    [else (member? (first (worm-game-worm-posns wg)) (rest (worm-game-worm-posns wg)))]))
(define (wg-render-final wg)
  (overlay/align "center" "middle"
                 (text
                  (cond
                   [(self-collision wg) (string-append "worm hit self. Score: " (number->string (length (worm-game-worm-posns wg))))]
                   [(border-collision wg) (string-append "worm hit border. Score: " (number->string (length (worm-game-worm-posns wg))))])
                 10 "red") (render-wg-full wg)))
(define (border-collision wg)
  (or (>= (posn-x (first (worm-game-worm-posns wg))) (image-width GAME-BOARD))
      (>= (posn-y (first (worm-game-worm-posns wg))) (image-height GAME-BOARD))
      (<= (posn-x (first (worm-game-worm-posns wg))) 0)
      (<= (posn-y (first (worm-game-worm-posns wg))) 0)))

(define (main-wg-full ws)
  (big-bang ws
    [on-tick tock-wg-full .1]
    [on-key handle-keys-wg-full]
    [to-draw render-wg-full]
    [stop-when collision wg-render-final]))
(define worm-start (make-worm-game "right" (list (make-posn (* 5 2 WORM-RADIUS) (* 6 2 WORM-RADIUS))) (food-create (make-posn 0 0))))
(main-wg-full worm-start)

;one bug here is in a worm length 2. back is removed before collision is detected, so if you have a collision with a worm length 2, it wont be detected.
;best solution i can think of is to change the data model to have a "prev direction" and then, in the collision check, if the length is 2, and the previous direction is the opposite
;of the current direction, we throw a collision