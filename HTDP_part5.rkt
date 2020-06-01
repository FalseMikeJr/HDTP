;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname HTDP_part5) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/batch-io)
(require 2htdp/image)
(require 2htdp/universe)
(require 2htdp/abstraction)
(require htdp/dir)

;421
; [List-of 1String] N -> [List-of String]
; bundles chunks of s into strings of length n
; idea take n items and drop n at a time
(define (bundle s n)
  (cond
    [(empty? s) '()]
    [else
     (cons (implode (take s n)) (bundle (drop s n) n))]))
 
; [List-of X] N -> [List-of X]
; keeps the first n items from l if possible or everything
(define (take l n)
  (cond
    [(< (length l) n) l]
    [(= n 0) '()]
    [else (cons (first l) (take (rest l) (- n 1)))]))
 
; [List-of X] N -> [List-of X]
; removes the first n items from l if possible or everything
(define (drop l n)
  (cond
    [(< (length l) n) '()]
    [(= n 0) l]
    [else (drop (rest l) (- n 1))]))
;(bundle '("a" "b" "c") 0) is not a valid use because it is essentially an infinite list of empty strings

;422
(define (list->chunks l n)
  (cond
    [(empty? l) '()]
    [else
     (cons (take l n) (list->chunks (drop l n) n))]))
(define (bundle.v2 l n)
  (map (lambda (x) (implode x)) (list->chunks l n)))
;423

