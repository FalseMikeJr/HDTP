;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname HTDP_redo_part2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/batch-io)
(require 2htdp/image)
(require 2htdp/universe)
;
;;ex 129
;
;(cons "white"
;      (cons "red"
;            (cons "blue" '())))
;(define-struct pair [left right])
;
;(define (our-cons a-value a-list)
;  (cond
;    [(empty? a-list) (make-pair a-value a-list)]
;    [(pair? a-list) (make-pair a-value a-list)]
;    [else (error "cons: second argument...")]))
;
;(define (our-first a-list)
;  (if (empty? a-list)
;      (error 'our-first "...")
;      (pair-left a-list)))
;
;(define (our-last a-list)
;  (if (empty? a-list)
;      (error 'our-last "...")
;      (pair-right a-list)))
;
;(define (contains-flatt? alon)
;  (cond
;    [(empty? alon) #false]
;    [(cons? alon)
;     (or (string=? (first alon) "Flatt") (contains-flatt? (rest alon)))]))
;;134
;(define (contains? alon str)
;  (cond
;    [(empty? alon) #false]
;    [(string=? (first alon) str) #true]
;    [else (contains? (rest alon) str)]))
;
;
;(define (how-many alos)
;  (cond
;    [(empty? alos) 0]
;    [else
;     (+ 1 (how-many (rest alos)))]))
;
;(define (sum aloAmounts)
;  (cond
;    [(empty? aloAmounts) 0]
;    [else (+ (first aloAmounts) (sum (rest aloAmounts)))]))
;
;(define (pos? alon)
;  (cond
;    [(empty? alon) #true]
;    [else (and (<= 0 (first alon)) (pos? (rest alon)))]))
;;only adds positive numbers in a list of numbers
;(define (checked-sum alon)
;  (cond
;    [(empty? alon) 0] 
;    [(pos? (cons (first alon) '())) (+ (first alon) (checked-sum (rest alon)))]
;    [else (+ 0 (checked-sum (rest alon)))]))
;;(checked-sum (cons -1 (cons 2 (cons -3 (cons 4 '())))))
;
;;140
;(define (all-true aloBools)
;  (cond
;    [(empty? aloBools) #true]
;    [(equal? #false (first aloBools)) #false]
;    [else (all-true (rest aloBools))]))
;
;(define (one-true aloBools)
;  (cond
;    [(empty? aloBools) #false]
;    [(equal? #true (first aloBools)) #true]
;    [else (one-true (rest aloBools))]))
;;141
;(define (cat l)
;  (cond
;    [(empty? l) ""]
;    [else (string-append (first l) (cat (rest l)))]))
;
;;142
;(define (ill-sized? loi n)
;  (cond
;    [(empty? loi) #false]
;    [(and (= (image-height (first loi)) n) (= (image-width (first loi)) n)) (ill-sized? (rest loi) n)]
;    [else (first loi)]))
;;143
;(define (average alot)
;  (/ (sum alot) (how-many alot)))
;(define (checked-average alot)
;  (cond
;    [(empty? alot) (error "list is empty")]
;    [else (/ (sum alot) (how-many alot))]))
;
;(define (sum-nel nel)
;  (cond
;    [(empty? (rest nel)) (first nel)]
;    [else (+ (first nel) (sum (rest nel)))]))
;;146
;(define (how-many-nel nel)
;  (cond
;    [(empty? (rest nel)) 1]
;    [else (+ 1 (how-many-nel (rest nel)))]))
;(define (avg-nel nel)
;  (/ (sum-nel nel) (how-many-nel nel)))
;
;;145
;(define (sorted>? nel)
;  (sorted-helper (rest nel) (first nel)))
;
;(define (sorted-helper nel num)
;  (cond
;    [(empty? nel) #true]
;    [(> num (first nel)) (sorted-helper (rest nel) (first nel))]
;    [else #false]))
;(define (all-true-nel nel)
;  (cond
;    [(empty? (rest nel)) (first nel)]
;    [(equal? #false (first nel)) #false]
;    [else (all-true-nel (rest nel))]))
;(define (one-true-nel nel)
;  (cond
;    [(empty? (rest nel)) (first nel)]
;    [(equal? #true (first nel)) #true]
;    [else (one-true-nel (rest nel))]))
;
;(define (copier n s)
;  (cond
;    [(zero? n) '()]
;    [(positive? n) (cons s (copier (sub1 n) s))]))
;(define (copier.v2 n s)
;  (cond
;    [(zero? n) '()]
;    [else (cons s (copier.v2 (sub1 n) s))]))
;;149
;;;errors out
;;(copier 0.1 "x")
;;;infinite loop
;;(copier.v2 0.1 "x")
;;150
;(define (add-to-pi n)
;  (cond
;    [(= 0 n) pi]
;    [else (add1 (add-to-pi (sub1 n)))]))
;;151
;(define (multiply n x)
;  (cond
;    [(= 0 n) 0]
;    [else (+ x (multiply (sub1 n) x))]))
;152
(define (col n img)
  (cond
    [(= 1 n) img]
    [else (above img (col (sub1 n) img))]))
(define (row n img)
  (cond
    [(= 1 n) img]
    [else (beside img (row (sub1 n) img))]))
;153

(define LECTURE_HALL
  (place-image (col 18 (row 8 (rectangle 10 10 "outline" "black"))) 40 90 (empty-scene 80 180)))
(define (add-balloons lop)
  (cond
    [(empty? lop) LECTURE_HALL]
    [else (place-image (circle 2 "solid" "red") (posn-x (first lop)) (posn-y (first lop)) (add-balloons (rest lop)))]))
(define-struct pair [balloon# lob])
(define (riot w0)
  
  (big-bang (make-pair w0 '())
    [to-draw render_riot]
    [on-tick tock_riot]
    ))
(define (tock_riot p)
  (cond
    [(<= (pair-balloon# p) 0) p]
    [else (make-pair (sub1 (pair-balloon# p)) (cons (make-posn (random 80) (random 180)) (pair-lob p)))]))
(define (render_riot p)
  (add-balloons (pair-lob p)))
    
;;where doll can be string color or (make-layer string doll)
;;color is analogous to first and doll is analogous to rest
;(define-struct layer [color doll])
;;154
;(define (colors an-rd)
;  (cond
;    [(string? an-rd) an-rd]
;    [else (string-append (layer-color an-rd) ", " (colors (layer-doll an-rd)))]))
;
;;155
;(define (inner an-rd)
;  (cond
;    [(string? an-rd) an-rd]
;    [else (inner (layer-doll an-rd))]))

(define HEIGHT 80)
(define WIDTH 100)
(define XSHOTS (/ WIDTH 2))
(define BACKGROUND (empty-scene WIDTH HEIGHT))
(define SHOT (triangle 6 "solid" "red"))
; A List-of-shots is one of: 
; – '()
; – (cons Shot List-of-shots)
; interpretation the collection of shots fired
; shot = a number representing the shot's y coordinate

(define (to-image w)
  (cond
    [(empty? w) BACKGROUND]
    [else
     (place-image SHOT XSHOTS (first w) (to-image (rest w)))]))
(define (tock w)
  (cond
    [(empty? w) '()]
    [else
     (cons (sub1 (first w)) (tock (rest w)))]))
(define (keyh w ke)
  (if (key=? ke " ") (cons HEIGHT w) w))
(define (main w0)
  (big-bang w0
    [on-tick tock_2]
    [on-key keyh]
    [to-draw to-image]))
;156
(check-expect (to-image (cons 9 (cons 10 '())))
              (place-image SHOT XSHOTS 9 (place-image SHOT XSHOTS 10 BACKGROUND)))
(check-expect (tock (cons 9 (cons 10 '())))
              (cons 8 (cons 9 '())))
(check-expect (keyh (cons 9 (cons 10 '())) " ")
              (cons HEIGHT (cons 9 (cons 10 '()))))
;158
(define (tock_2 w)
  (cond
    [(empty? w) '()]
    [else
     (cond [(> (first w) 0) (cons (sub1 (first w)) (tock_2 (rest w)))]
           [else (tock_2 (rest w))])]))
