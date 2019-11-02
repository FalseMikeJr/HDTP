;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname HTDP_redo_part2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/batch-io)
(require 2htdp/image)
(require 2htdp/universe)

;ex 129

(cons "white"
      (cons "red"
            (cons "blue" '())))
(define-struct pair [left right])

(define (our-cons a-value a-list)
  (cond
    [(empty? a-list) (make-pair a-value a-list)]
    [(pair? a-list) (make-pair a-value a-list)]
    [else (error "cons: second argument...")]))

(define (our-first a-list)
  (if (empty? a-list)
      (error 'our-first "...")
      (pair-left a-list)))

(define (our-last a-list)
  (if (empty? a-list)
      (error 'our-last "...")
      (pair-right a-list)))

(define (contains-flatt? alon)
  (cond
    [(empty? alon) #false]
    [(cons? alon)
     (or (string=? (first alon) "Flatt") (contains-flatt? (rest alon)))]))
;134
(define (contains? alon str)
  (cond
    [(empty? alon) #false]
    [(string=? (first alon) str) #true]
    [else (contains? (rest alon) str)]))


(define (how-many alos)
  (cond
    [(empty? alos) 0]
    [else
     (+ 1 (how-many (rest alos)))]))

(define (sum aloAmounts)
  (cond
    [(empty? aloAmounts) 0]
    [else (+ (first aloAmounts) (sum (rest aloAmounts)))]))

(define (pos? alon)
  (cond
    [(empty? alon) #true]
    [else (and (<= 0 (first alon)) (pos? (rest alon)))]))
;only adds positive numbers in a list of numbers
(define (checked-sum alon)
  (cond
    [(empty? alon) 0] 
    [(pos? (cons (first alon) '())) (+ (first alon) (checked-sum (rest alon)))]
    [else (+ 0 (checked-sum (rest alon)))]))
(checked-sum (cons -1 (cons 2 (cons -3 (cons 4 '())))))

;140
(define (all-true aloBools)
  (cond
    [(empty? aloBools) #true]
    [(equal? #false (first aloBools)) #false]
    [else (all-true (rest aloBools))]))

(define (one-true aloBools)
  (cond
    [(empty? aloBools) #false]
    [(equal? #true (first aloBools)) #true]
    [else (one-true (rest aloBools))]))


