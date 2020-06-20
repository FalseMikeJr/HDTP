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
(define (partition s n)
  (cond
    [(equal? "" s) '()]
    [(or (> n (string-length s)) (zero? n)) (cons s '())]
    [else (cons (substring s 0 n) (partition (substring s n (string-length s)) n))]))

; [List-of Number] -> [List-of Number]
; produces a sorted version of alon
; assume the numbers are all distinct
;426
(define (quick-sort< alon)
  (cond
    [(empty? alon) '()]
    [(empty? (rest alon)) (cons (first alon) '())]
    [else (local ((define pivot (first alon)))
            (append (quick-sort< (smallers alon pivot))
                    (list pivot)
                    (quick-sort< (largers alon pivot))))]))
 
; [List-of Number] Number -> [List-of Number]
(define (largers alon n)
  (cond
    [(empty? (rest alon)) (if (> n (first alon)) '() (cons (first alon) '()))]
    [else (if (> (first alon) n)
              (cons (first alon) (largers (rest alon) n))
              (largers (rest alon) n))]))
 
; [List-of Number] Number -> [List-of Number]
(define (smallers alon n)
  (cond
    [(empty? (rest alon)) (if (< n (first alon)) '() (cons (first alon) '()))]
    [else (if (< (first alon) n)
              (cons (first alon) (smallers (rest alon) n))
              (smallers (rest alon) n))]))
;427
; List-of-numbers -> List-of-numbers
; produces a sorted version of l
(define (sort> l)
  (cond
    [(empty? l) '()]
    [(cons? l) (insert (first l) (sort> (rest l)))]))
 
; Number List-of-numbers -> List-of-numbers
; inserts n into the sorted list of numbers l 
(define (insert n l)
  (cond
    [(empty? l) (cons n '())]
    [else (if (>= n (first l))
              (cons n l)
              (cons (first l) (insert n (rest l))))]))

(define (sort< l)
  (cond
    [(empty? l) '()]
    [(cons? l) (insert< (first l) (sort< (rest l)))]))
(define (insert< n l)
  (cond
    [(empty? l) (cons n '())]
    [else (if (<= n (first l))
               (cons n l)
               (cons (first l) (insert< n (rest l))))]))
(define (quick-sort.v2< alon threshold)
  (cond
    [(< (length alon) threshold) (sort< alon)]
    [else (local ((define pivot (first alon)))
            (append (quick-sort.v2< (smallers alon pivot) threshold)
                    (list pivot)
                    (quick-sort.v2< (largers alon pivot) threshold)))]))
;428
(define (quick-sort.v3< alon)
  (cond
    [(empty? alon) '()]
    [(empty? (rest alon)) (cons (first alon) '())]
    [else (local ((define pivot (first alon)))
            (append (quick-sort.v3< (smallers.v4 alon pivot))
                    (quick-sort.v3< (largers.v4 alon pivot))))]))
;429
(define (smallers.v4 alon pivot)
  (filter (lambda (x) (< x pivot)) alon))
(define (largers.v4 alon pivot)
  (filter (lambda (x) (> x pivot)) alon))
;430
(define (quick-sort<.v5 alon)
  (cond
    [(empty? alon) '()]
    [else (local ((define pivot (first alon)))
            (separate alon pivot '() '()))]))
(define (separate alon pivot smalls larges)
  (cond
    [(empty? alon) (append (quick-sort<.v5 smalls) (list pivot) (quick-sort<.v5 larges))]
    [(> (first alon) pivot) (separate (rest alon) pivot smalls (cons (first alon) larges))]
    [(< (first alon) pivot) (separate (rest alon) pivot (cons (first alon) smalls) larges)]
    [else (separate (rest alon) pivot smalls larges)]))
;428/430 final
(define (quick-sort.v6 alon compare)
  (cond
    [(empty? alon) '()]
    [else (local (
                 (define pivot (first alon))
                 (define (separate alon pivots smalls larges)
                   (cond
                     ;using (rest pivots) because we want to exclude 1 pivot value to avoid the duplicate in the list from grabbing the pivot initially, then looping over it in the list
                     [(and (empty? alon) (equal? > compare)) (append (quick-sort.v6 larges compare) (rest pivots) (quick-sort.v6 smalls compare))]
                     [(empty? alon) (append (quick-sort.v6 smalls compare) (rest pivots) (quick-sort.v6 larges compare))]
                     [(> (first alon) (first pivots)) (separate (rest alon) pivots smalls (cons (first alon) larges))]
                     [(< (first alon) (first pivots)) (separate (rest alon) pivots (cons (first alon) smalls) larges)]
                     [else (separate (rest alon) (cons (first alon) pivots) smalls larges)])))
            (separate alon (list pivot) '() '()))]))

;431
;1)bundling an empty/1-item list, or bundling where n = 0
;2)an empty list or the entire list
;3)separates it into removing a sub-list of n items, and dropping a sub-list of n items from the main list
;4)we need to combine, and we just need the n value
;1)sorting an empty/1-item list
;2)returning the empty/1-item list
;3)separates it into finding the larger/smaller values than a pivot value (and may collect pivot values too)

;433 pretty sure i wrote a checked version originally, if n = 0, it terminates
;434 the pivot is never removed from the list, so the list will not get smaller and smaller. This is due to the if (<= (first l) n) piece of code
;435
;idea is to use quick-sort.v6, but pass (rest alon) to the functions
(define (quick-sort.v7 alon compare)
  (cond
    [(empty? alon) '()]
    [else (local (
                 (define (separate alon pivots smalls larges)
                   (cond
                     [(and (empty? alon) (equal? > compare)) (append (quick-sort.v6 larges compare) pivots (quick-sort.v6 smalls compare))]
                     [(empty? alon) (append (quick-sort.v6 smalls compare) pivots (quick-sort.v6 larges compare))]
                     [(> (first alon) (first pivots)) (separate (rest alon) pivots smalls (cons (first alon) larges))]
                     [(< (first alon) (first pivots)) (separate (rest alon) pivots (cons (first alon) smalls) larges)]
                     [else (separate (rest alon) (cons (first alon) pivots) smalls larges)])))
            (separate (rest alon) (list (first alon)) '() '()))]))
;437
(define (special P)
  (cond
    [(empty? P) (solve.v3 P)]
    [else
     (combine-solutions.v3
      P
      (special (rest P)))]))
(define (solve arg)
  0)
(define (combine-solutions arg1 arg2)
  (+ 1 arg2))
(define (solve.v2 arg)
  '())
(define (combine-solutions.v2 arg1 arg2)
  (cons (* -1 (first arg1)) arg2))
(define (solve.v3 arg)
  '())
(define (combine-solutions.v3 arg1 arg2)
  (cons (string-upcase (first arg1)) arg2))
;for structural recursion, and an empty list, solve is EXTREMELY trivial

;438
;starts off at the min value between 2 numbers, and checks if both are divisible by it
;if so, returns the number, else recurses and checks the next smallest number 

(define (gcd-structural n m)
  (local (; N -> N
          ; determines the gcd of n and m less than i
          (define (greatest-divisor-<= i)
            (cond
              [(= i 1) 1]
              [else
               (if (= (remainder n i) (remainder m i) 0)
                   i
                   (greatest-divisor-<= (- i 1)))])))
    (greatest-divisor-<= (min n m))))

(define (gcd-generative n m)
  (local (; N[>= 1] N[>=1] -> N
          ; generative recursion
          ; (gcd L S) == (gcd S (remainder L S)) 
          (define (clever-gcd L S)
            (cond
              [(= S 0) L]
              [else (clever-gcd S (remainder L S))])))
    (clever-gcd (max m n) (min m n))))

;442
(define (create-tests size)
  (local (
          (define (create-tests-loc curr size)
            (cond
              [(= size 0) curr]
              [else (create-tests-loc (cons (random 1000) curr) (+ size -1))])))
    (create-tests-loc '() size)))
(define (sorted? l)
  (cond
    [(empty? (rest l)) #true]
    [else (and (<= (first l) (second l)) (sorted? (rest l)))]))
;443
;you'd have an indefinite number of conditions

;444
;the function is called twice, first for the set of divisors in S,
;and next for the set of divisors in L. Since L is larger than S,
;we pass S in the L function call because a valid divisor of L which is larger than S
;will never be a divisor of S since S / divisor < 1
(define SMALL 32)
(define (sierpinski side)
  (cond
    [(<= side SMALL) (triangle side 'outline 'red)]
    [else
     (local ((define half-sized (sierpinski (/ side 2))))
       (above half-sized (beside half-sized half-sized)))]))

(define (poly x)
  (* (- x 2) (- x 4)))

;445
(check-satisfied (find-root poly 3 20) within-tolerance)
(define (within-tolerance number)
  (<= (- (abs number) 4) ε))

(define ε 0.01)
(define (find-root f left right)
  (cond
    [(<= (- right left) ε) left]
    [else
      (local ((define mid (/ (+ left right) 2))
              (define f@mid (f mid))
              (define f@right (f right))
              (define f@left (f left)))
        (cond
          [(or (<= f@left 0 f@mid) (<= f@mid 0 f@left))
           (find-root f left mid)]
          [(or (<= f@mid 0 f@right) (<= f@right 0 f@mid))
           (find-root f mid right)]))]))

;446 uncommenting 445
;447 it will choose the left root
;448
;termination argument: choose an interval such that the assumption can hold true
;otherwise, the algorithm can't tell if the midpoint should be the new left or the new right

;449
(define (find-root.v2 f left right)
  (cond
    [(<= (- right left) ε) left]
    [else
      (local ((define mid (/ (+ left right) 2))
              (define f@mid (f mid))
              (define (find-root-helper f left right f@left f@right)
                (cond
                  [(or (<= f@left 0 f@mid) (<= f@mid 0 f@left))
                   (find-root-helper f left mid (f left) f@mid)]
                  [(or (<= f@mid 0 f@right) (<= f@right 0 f@mid))
                   (find-root f mid right f@mid (f right))])))
        (find-root-helper f left right (f left) (f right)))]))
;450
(define (find-root.monotonic-increase f left right)
  (cond
    [(<= (- right left) ε) left]
    [else
     (local ((define mid (/ (+ left right) 2))
             (define f@mid (f mid))
             (define (find-root-helper f left right f@left f@right)
               (cond
                 [(< f@mid 0) (find-root-helper f mid right f@mid (f right))]
                 [(> f@mid 0) (find-root-helper f left mid (f left) (f right))]
                 [else mid])))
       (find-root-helper f left right (f left) (f right)))]))

;451
(define-struct table [length array])
; A Table is a structure:
;   (make-table N [N -> Number])
(define (table-ref t i)
  ((table-array t) i))
;kinda weird solution but wanted to use some lambdas
(define (find-linear t)
  (local (
          (define len (table-length t))
          (define num-list (build-list len (lambda(x) x))))
    (foldr (lambda (row agg) (if (<= (abs (table-ref t row)) ε) row agg)) '() num-list)))
(define table1 (make-table 3 (lambda (i) (+ i -1))))

(define (find-binary t)
  (local ( 
          (define (find-binary-loc left right)
            (local (
                    (define mid (/ (+ left right) 2))
                    (define f@mid (table-ref t mid)))
              (cond
                [(<= (abs f@mid) ε) mid]
                [(> f@mid 0) (find-binary-loc left mid)]
                [(< f@mid 0) (find-binary-loc mid right)]))))
    (find-binary-loc 0 (+ (table-length t) -1))))
(define table2 (make-table 3 (lambda (i) (* (- i 2) (+ i 4)))))

;453

(define (tokenize line)
  (local (
          (define (tokenize-local line curr)
            (cond
              [(empty? line) curr]
              [(string-whitespace? (first line)) (tokenize-local (rest line) curr)]
              [else (tokenize-local (rest line) (string-append curr (first line)))])))
    (tokenize-local line "")))

;454
(define (create-matrix n l)
  (local (
          (define (create-row n-loc l-loc)
            (cond
              [(= 0 n-loc) '()]
              [else (cons (first l-loc) (create-row (+ n-loc -1) (rest l-loc)))]))
          (define (remove-row n-loc l-loc)
            (cond
              [(= 0 n-loc) l-loc]
              [else (remove-row (+ n-loc -1) (rest l-loc))])))
    (cond
      [(empty? l) '()]
      [else (cons (create-row n l) (create-matrix n (remove-row n l)))])))
;455
(define ε1 .1)
(define (slope r1 f)
  (local (
          (define numerator (- (f (+ r1 ε1)) (f (- r1 ε1))))
          (define denominator (- (+ r1 ε1) (- r1 ε1))))
    (/ numerator denominator)))
;456
(define (root-of-tangent f r1)
  (- r1 (/ (f r1) (slope r1 f))))
;choose values that don't lie exactly between 2 roots (i.e. for (x-2)(x-4), dont choose 3)
(define (newton f r1)
  (cond
    [(<= (abs (f r1)) ε) r1]
    [else (newton f (root-of-tangent f r1))]))
(define poly2
  (lambda(x) (* (- x 2) (- x 4))))
;457
(define (double-amount given rate)
  (local (
          (define (double-loc curr count)
            (if (>= curr (* 2 given)) count (double-loc (+ curr (* curr rate)) (+ 1 count)))))
    (double-loc given 0)))
(define (double-amount.v2 rate)
  (/ (log 2) (log (+ 1 rate))))

;458
(define (integrate-kepler f a b)
  (local (
          (define mid (/ (+ a b) 2))
          (define fa (f a))
          (define fb (f b)))
    (* (- b a) (+ fa fb) .5)))
;459 accidentally skipped, but it's a simpler version of 460
;460
(define (integrate-dc f a b)
  (local (
          (define midpoint (/ (+ a b) 2)))
    (cond
      [(<= (- b a) ε1) (integrate-kepler f a b)]
      [else (+ (integrate-dc f a midpoint) (integrate-dc f midpoint b))])))
;461
(define (integrate-adaptive f a b)
  (local (
          (define midpoint (/ (+ a b) 2))
          (define trap-whole (integrate-kepler f a b))
          (define trap-sum (+ (integrate-kepler f a midpoint) (integrate-kepler f midpoint b)))
          (define tolerance (* ε1 (- b a))))
    (cond
      [(<= (abs (- trap-whole trap-sum)) tolerance) trap-whole]
      [else (+ (integrate-adaptive f a midpoint) (integrate-adaptive f midpoint b))])))


; Equation -> [List-of Number]
; extracts the left-hand side from a row in a matrix
(define (lhs e)
  (reverse (rest (reverse e))))
 
; Equation -> Number
; extracts the right-hand side from a row in a matrix
(define (rhs e)
  (first (reverse e)))
;462
(define (check-solution soe sol)
  (foldr (lambda (system bool-sum) (and bool-sum (= (plug-in (lhs system) sol) (rhs system)))) #t soe))

(define (plug-in lh sol)
  (foldr (lambda (l s summ) (+ summ (* l s))) 0  lh sol))

(define M ; an SOE 
  (list (list 2 2  3 10) ; an Equation 
        (list 2 5 12 31)
        (list 4 1 -2  1)))
 
(define S '(1 1 2)) ; a Solution
(check-expect (check-solution M S) #t)
;463
(define M2
  (list (list 2 2 3 10)
        (list 0 3 9 21)
        (list 0 0 1 2)))

(check-solution M2 S)
;464
(define M3
  '((2 2 3 10) (0 3 9 21) (0 -3 -8 -19)))
(check-solution M3 S)
;465
(define (subtract eq1 eq2)
  (local (
          (define eq1posn1 (first eq1))
          (define eq2posn2 (first eq2))
          (define multiple (/ eq1posn1 eq2posn2))
          (define (new-eq2 eq-loc)
            (if (empty? eq-loc) '() (cons (* (first eq-loc) multiple) (new-eq2 (rest eq-loc)))))
          (define (subtract-direct eq1 eq2)
            (map (lambda (1field 2field) (- 1field 2field)) eq1 eq2)))
    (rest (subtract-direct eq1 (new-eq2 eq2)))))
;466
;subtracts top equation in matrix from eqns below it to produce matrices with leading coefficient removed
(define (subtract-matrix M)
  (local (
          (define top-eqn (first M)))
  (cons top-eqn
        (foldr (lambda (eqn summ) (cons (subtract eqn top-eqn) summ)) '() (rest M)))))

(define (triangulate M)
    (cond
      [(empty?  M) '()]
      [else (local (
                    (define rotated-M (rotate-mat M)))
              (cons (first rotated-M) (triangulate (rest (subtract-matrix rotated-M)))))]))
;467/468
;reorders a matrix to place the first nonzero leading row at the top of the matrix
(define (rotate-mat M)
  (local (
          (define size (length M))
          (define (rotate-loc M-loc count)
            (cond
              [(= count size) (error "all leading coefficients nonzero")]
              [(zero? (first (first M-loc))) (rotate-loc (append (rest M-loc) (list (first M-loc))) (+ 1 count))]
              [else M-loc])))
    (rotate-loc M 0)))

;469
;this can be cleaned up, likely with the nested local definition removed
;however this is fairly readable...
(define (solve-SOE tri-SOE)
  (local (
    (define (solve-local rev-soe-loc rev-vals)
      (if (empty? rev-soe-loc)
          (reverse rev-vals)
          (local (
                  ;x1 x2 x3
                  (define left (lhs (first rev-soe-loc)))
                  ;val
                  (define right (rhs (first rev-soe-loc)))
                  ;x3 x2 x1 with x0 removed
                  (define known-vals-rev (reverse (rest left)))
                  ;multiplies the row out with the known vals and sums them
                  (define known-vals-sum (foldr (lambda (mat-item val-item summ) (+ summ (* mat-item val-item))) 0 known-vals-rev rev-vals))
                  ;takes the rhs of the equation and subtracts the constant on the left hand side from it, and divides it by the constant in front of the
                  ;unknown variable, to solve for the unknown variable
                  (define new-val (/ (- right known-vals-sum) (first left))))
            (solve-local (rest rev-soe-loc) (cons new-val rev-vals)))))) ; this line is essentially a foldr
    (reverse (solve-local (reverse tri-SOE) '()))))

(define (solve-SOE.v2 tri-SOE)
  (local (
          (define (solve-local rev-soe-loc)
            (foldl
             (lambda (soe-row agg)
               (cond
                 [(= 2 (length soe-row)) (cons (/ (rhs soe-row) (first soe-row)) agg)]
                 [else (cons
                        (/
                         (-
                          (rhs soe-row)
                          (foldr (lambda (mat-item val-item summ) (+ summ (* mat-item val-item))) 0 (reverse (rest (lhs soe-row))) agg))
                         (first soe-row))
                        agg)]))
             '()
             rev-soe-loc)))
    (solve-local (reverse tri-SOE))))
;cleaner version
(define (solve-SOE.v3 tri-SOE)
  ;creates the array of values [x1 .... xn]
  (foldl
   (lambda (soe-row agg)
     (cond
       [(= 2 (length soe-row)) (cons (/ (rhs soe-row) (first soe-row)) agg)]
       [else (cons
              ;finds the newest value by dividing the (subtraction of the sum of the known LHS values from the RHS value) by the coefficient of the unknown value
              ;and cons's it to the other known values
              (/
               (-
                (rhs soe-row)
                (foldr (lambda (mat-item val-item summ) (+ summ (* mat-item val-item))) 0 (reverse (rest (lhs soe-row))) agg))
               (first soe-row))
              agg)]))
   '()
   ;we pass in the reversed SOE because the bottom of the triangled SOE has the first known value already given, and we build up from there
   (reverse tri-SOE)))
             

;470
(define (gauss M)
  (solve-SOE.v3 (triangulate M)))

;471
(define sample-graph
  (list
   (list 'A (list 'B 'E))
   (list 'B (list 'E 'F))
   (list 'C (list 'D))
   (list 'D '())
   (list 'E (list 'C 'F))
   (list 'F (list 'D 'G))
   (list 'G '())))
(define simple-graph
  (list
   (list 'A (list 'B))
   (list 'B (list 'A))))
(define cyclic-graph
  (list
   (list 'A (list 'B 'E))
   (list 'B (list 'E 'F))
   (list 'E (list 'C 'F))
   (list 'C (list 'B 'D))
   (list 'F (list 'D 'G))
   (list 'D '())
   (list 'G '())))

(define (neighbors n g)
  (cond
    [(empty? g) (error "node not found")]
    [(equal? n (first (first g))) (first (rest (first g)))]
    [else (neighbors n (rest g))]))

; Node Node Graph -> [Maybe Path]
; finds a path from origination to destination in G
; if there is no path, the function produces #false
(define (find-path origination destination G)
  (cond
    [(symbol=? origination destination) (list destination)]
    [else (local ((define next (neighbors origination G))
                  (define candidate
                    (find-path/list.v2 next destination G)))
            (cond
              [(boolean? candidate) #false]
              [else (cons origination candidate)]))]))
 
; [List-of Node] Node Graph -> [Maybe Path]
; finds a path from some node on lo-Os to D
; if there is no path, the function produces #false
(define (find-path/list lo-Os D G)
  (cond
    [(empty? lo-Os) #false]
    [else (local ((define candidate
                    (find-path (first lo-Os) D G)))
            (cond
              [(boolean? candidate)
               (find-path/list (rest lo-Os) D G)]
              [else candidate]))]))
;472
;it finds the longer path A -> B -> E -> F -> G
;instead of A -> B -> F -> G
;it finds it because it is the first successful path it finds, and it doesnt continue to look for more paths after it
;successfully finds this one
(define (test-on-all-nodes g)
  ;grabs all nodes
  (andmap (lambda (x)
            ;and compares each with all other nodes to see if a path exists
            (andmap (lambda (y) (not (boolean? (find-path (first x) (first y) g)))) g)) g))

;473
;find-path works from 'B to 'C but infinitely recurses for test-on-all-nodes because it wont find a path from
;B to A and so will keep looping
;474
; Node Node Graph -> [Maybe Path]
; finds a path from origination to destination in G
; if there is no path, the function produces #false
(define (find-path.v2 origination destination G)
  (local (
          (define next (neighbors origination G))
          
          (define (find-path/list lo-Os D G)
            (cond
              [(empty? lo-Os) #f]
              [else (local (
                           (define candidate (find-path (first lo-Os) D G)))
                    (cond
                      [(boolean? candidate)
                       (find-path/list (rest lo-Os) D G)]
                      [else candidate]))]))
          
          (define candidate (find-path/list next destination G)))
    
    (cond
      [(boolean? candidate) #f]
      [else (cons origination candidate)])))
;475
(define (find-path/list.v2 lo-Os D G)
  (cond
    [(empty? lo-Os) #f]
    [else
     ;this will return the last path, unlike the v1 version which will return the first
     (foldr (lambda (x agg) (if (boolean? agg) (find-path x D G) agg)) #f lo-Os)]))
;the racket ormap function would definitely be helpful here. we'd be able to use it in place of the foldr function

;476
(define-struct transition [current key next])
(define-struct fsm [initial transitions final])
 
; An FSM is a structure:
;   (make-fsm FSM-State [List-of 1Transition] FSM-State)
; A 1Transition is a structure:
;   (make-transition FSM-State 1String FSM-State)
; An FSM-State is String.
 
; data example: see exercise 109
 
(define fsm-a-bc*-d
  (make-fsm
   "AA"
   (list (make-transition "AA" "a" "BC")
         (make-transition "BC" "b" "BC")
         (make-transition "BC" "c" "BC")
         (make-transition "BC" "d" "DD"))
   "DD"))

(define (fsm-match? an-fsm a-string)
  (local (
          (define (match-local curr prev)
            (local (
                    (define this-trans (find-in-fsm curr))
                    (define prev-trans (find-in-fsm prev)))
              (cond
                ;if first item and it matches with the initial state, return the initial state, otherwise false
                [(equal? prev #f) (if (equal? (fsm-initial an-fsm) (transition-current this-trans)) (transition-current this-trans) #f)]
                ;if it's the final, and previous' next equal to current's current, return the final state, otherwise false
                [(equal? (transition-next this-trans) (fsm-final an-fsm)) (if (equal? (transition-next prev-trans) (transition-current this-trans)) (transition-next this-trans) #f)]
                ;if previous's next equal to currents current, return the transition, otherwise false
                [(equal? (transition-next prev-trans) (transition-current this-trans)) (transition-current this-trans)]
                [else #f])))
          ;returns the transition based on the given key
          ;or false if not found
          (define (find-in-fsm key)
            (foldr (lambda (trans match) (if (equal? (transition-key trans) key) trans match)) #f (fsm-transitions an-fsm)))
          ;returns the list of transitions like (list "AA" "BC "BC" "DD")
          ;false if the regular expression doesnt match at some point
          (define folded-expr
            (foldl (lambda (curr prev accum)
                       (cond
                         [(boolean? accum) #f]
                         [else
                          (local ((define match-so-far (match-local curr prev)))
                            (if (boolean? match-so-far) #f (cons match-so-far accum)))])) '() (explode a-string) (cons #f (reverse (rest (reverse (explode a-string))))))))
    ;if folded-expr is boolean, false, else return true if first value = "AA" and last value = "DD", otherwise false
    (if (boolean? folded-expr) #f (and (equal? (first folded-expr) (fsm-final an-fsm)) (equal? (first (reverse folded-expr)) (fsm-initial an-fsm))))))
;477
(define (arrangements w)
  (cond
    [(empty? w) '(())]
    [else
      (foldr (lambda (item others)
               (local ((define without-item
                         (arrangements (remove item w)))
                       (define add-item-to-front
                         (map (lambda (a) (cons item a))
                              without-item)))
                 (append add-item-to-front others)))
        '()
        w)]))
;478
;these arrangements are rotationally equivalent to the ones given

(define QUEENS 8)
; A QP is a structure:
;   (make-posn CI CI)
; A CI is an N in [0,QUEENS).
; interpretation (make-posn r c) denotes the square at 
; the r-th row and c-th column

;479
(define (threatening? qp1 qp2)
  (or (= (posn-x qp1) (posn-x qp2)) (= (posn-y qp1) (posn-y qp2)) (= (abs (- (posn-x qp1) (posn-x qp2))) (abs (- (posn-y qp1) (posn-y qp2))))))
;480
;dont really care about rendering the board
(define (render-queens n qp-list q-img)
  n)
;481
;creates a function for a board of size n to check if a solution is valid
(define (n-queens-solution? n)
  (lambda(qp-list)
    (if (not (equal? (length qp-list) n)) #f
    (foldr (lambda (qp valid)
             (if (not valid)
                 valid
                 ;this can probably be made into another foldr or an andmap function
                 (local (
                         (define (goodness-check qp-loc qp-list-loc coord-match-count)
                           (cond
                             [(empty? qp-list-loc) #t]
                             [(> coord-match-count 1) #f]
                             ;needed a way to make sure it didnt invalidate a solution on a collision with qp-loc and itself within qp-list-loc
                             [(and (= (posn-x qp-loc) (posn-x (first qp-list-loc))) (= (posn-y qp-loc) (posn-y (first qp-list-loc)))) (goodness-check qp-loc (rest qp-list-loc) (+ 1 coord-match-count))]
                             [(threatening? qp-loc (first qp-list-loc)) #f]
                             [else (goodness-check qp-loc (rest qp-list-loc) coord-match-count)])))
                   (and valid (goodness-check qp qp-list 0))))) #t qp-list))))

(define 4soln (list (make-posn 0 1) (make-posn 1 3) (make-posn 2 0) (make-posn 3 2)))
(define 4soln-bad1 (list (make-posn 1 1) (make-posn 1 3) (make-posn 2 0) (make-posn 3 2)))
(define (set=? list1 list2)
  (cond
    [(not (equal? (length list1) (length list2))) #f]
    [else
     (foldr (lambda (item1 valid)
              (local (
                      (define (contained-in-other item other-list)
                        (cond
                          [(empty? other-list) #f]
                          [(equal? item (first other-list)) #t]
                          [else (contained-in-other item (rest other-list))])))
                (and valid (contained-in-other item1 list2))))
            #t
            list1)]))
;a board collects those positions where a queen can still be placed
;a board is a list of posns
;482

(define (place-queens.v2 a-board n)
  (local (
          (define (place-queens.v2-loc a-board-loc queen-spots-loc n-loc1)
            (local (
                    (define (place-queens-loc safe-board queen-spots n-loc)
                      (cond
                        [(= 0 n-loc) queen-spots]
                        [(and (empty? safe-board) (> n-loc 0)) #f]
                        [else (place-queens.v2-loc (add-queen (rest safe-board) (first safe-board)) (cons (first safe-board) queen-spots) (- n-loc 1))]))
                    (define first-move (place-queens-loc a-board-loc queen-spots-loc n-loc1)))
              (cond
                [(< (length a-board-loc) n-loc1) #f]
                [(boolean? first-move) (place-queens.v2-loc (rest a-board-loc) queen-spots-loc n-loc1)]
                [else first-move]))))
    (place-queens.v2-loc a-board '() n)))
                            

;483
(define (add-queen a-board qp)
  (filter (lambda (coords) (not (threatening? coords qp))) a-board))
(define (board0 n)
  (local (
    (define (make-board width height)
      (cond
        [(= n height) '()]
        [(= (- n 1) width) (cons (make-posn width height) (make-board 0 (+ 1 height)))]
        [else (cons (make-posn width height) (make-board (+ 1 width) height))])))
    (make-board 0 0)))
      
