;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |HDTP Section2|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
;;8.3 exercise
;(define (contains-flatt? alon)
;  (cond
;    [(empty? alon) #false]
;    [else
;     (cond
;       [(string=? (first alon) "Flatt") #true]
;       [else (contains-flatt? (rest alon))])]
;    )
;  )
;
;(check-expect (contains-flatt? '()) #false)
;
;(check-expect (contains-flatt? (cons "Find" '())) #false)
;
;(check-expect (contains-flatt? (cons "Flatt" '())) #true)
;
;(check-expect
;  (contains-flatt?
;    (cons "A" (cons "Flatt" (cons "C" '()))))
;  #true)
;
;;exercise 134
;(define (contains? str alon)
;  (cond
;    [(or (empty? alon) (= str "")) #false]
;    [else (cond
;            [(string=? (first alon) str) #true]
;            [else (contains? (rest alon) str)]
;            )]
;    )
;  )
;
;(define (sum loa)
;  (cond
;    [(empty? loa) 0]
;    [else (+ (first loa) (sum (rest loa)))]
;    )
;  )
;
;(define (pos? lon)
;  (cond
;    [(empty? lon) #true]
;    [else (cond
;            [(< (first lon) 0) false]
;            [else (pos? (rest lon))]
;            )
;          ]
;    )
;  )
;
;(define (checked-sum lon)
;  (cond
;    [(empty? lon) 0]
;    [else (cond
;            [(< (first lon) 0) (error "argument less than 0")]
;            [else (+ (first lon) (sum (rest lon)))])]))
;
;(define (cat l)
;  (cond
;    [(empty? l) ""]
;    [else (string-append (first l) (cat (rest l)))]))
;
;;145
;(define (sorted? ne-l)
;  (cond
;    [(empty? (rest ne-l)) #true]
;    [else (cond
;            [(>= (first ne-l) (first (rest ne-l))) (sorted? (rest ne-l))]
;            [else #false]
;            )
;          ]
;    ))
;
;(define (how-many? ne-l)
;  (cond
;    [(empty? ne-l) 0]
;    [else (+ 1 (how-many? (rest ne-l)))]
;    )
;  )
;
;;150
;(define (add-to-pi n)
;  (cond
;    [(zero? n) pi]
;    [else (add1 (add-to-pi (sub1 n)))]
;    )
;  )
;
;;151
;(define (multiply n x)
;  (cond
;    [(zero? x) 0]
;    [else (+ n (multiply n (- x 1)))]
;    )
;  )
;
;;152
;
;(define PIXEL-SIZE 10)
;(define SQUARE (square PIXEL-SIZE "outline" "green"))
;(define ATTACK-WIDTH 8)
;(define ATTACK-HEIGHT 18)
;(define ATTACK-SCENE (empty-scene (* PIXEL-SIZE ATTACK-WIDTH) (* PIXEL-SIZE ATTACK-HEIGHT)))
;(define MY-POSNS (cons (make-posn 0 1) (cons (make-posn 4 5) '())))
;
;(define (col n img)
;  (cond
;    [(= 1 n) img]
;    [else (above img (col (sub1 n) img))]
;    )
;  )
;
;(define (row n img)
;  (cond
;    [(= 1 n) img]
;    [else (beside img (row (sub1 n) img))]
;    )
;  )
;;153
;(define (matrix n m)
;    (place-image (col m (row n SQUARE)) (/ (* PIXEL-SIZE ATTACK-WIDTH) 2) (/ (* PIXEL-SIZE ATTACK-HEIGHT) 2) ATTACK-SCENE)
;  )
;
;(define lecture-hall
;  (matrix 8 18)
;  )
;
;(define (add-balloons lo-posns)
;  (cond
;    [(empty? lo-posns) lecture-hall]
;    [else (place-image (circle 3 "solid" "red") (* 10 (posn-x (first lo-posns))) (* 10 (posn-y (first lo-posns))) (add-balloons (rest lo-posns)))]
;    )
;  )
;
;(define (count los s)
;  (cond
;    [(empty? los) 0]
;    [(string=? s (first los)) (+ 1 (count (rest los) s))]
;    [else (count (rest los) s)]))
;
;
;;160
;(define es '())
;(define (in? x s)
;  (member? x s))
;; Number Son.L -> Son.L
;; removes x from s 
;(define s1.L
;  (cons 1 (cons 1 '())))
;         
;(check-expect
; (set-.L 1 s1.L) es)
;         
;(define (set-.L x s)
;  (remove-all x s))
;(define (set+.L x s)
;  (cons x s))
;
;          
;        	
;; Number Son.R -> Son.R
;; removes x from s
;(define s1.R
;  (cons 1 '()))
;         
;(check-expect
; (set-.R 1 s1.R) es)
;         
;(define (set-.R x s)
;  (remove x s))
;(define (set+.R x s)
;  (cond
;    [(not (in? x s)) (cons x s)]
;    [else s]))

;161, 162
(define SET_WAGE 14)
; List-of-numbers -> List-of-numbers
; computes the weekly wages for all given weekly hours
(define (wage* whrs)
  (cond
    [(empty? whrs) '()]
    [(<= 100 (first whrs)) (error "hours worked exceed 100")]
    [else (cons (wage (first whrs)) (wage* (rest whrs)))]))
 
; Number -> Number
; computes the wage for h hours of work
(define (wage h)
  (* SET_WAGE h))
(check-expect (wage* (cons 28 '())) (cons (* 28 SET_WAGE) '()))

;163
(define (convertFC f)
  (/ (*(- f 32) 5) 9))
(define (convertFC* flist)
  (cond
  [(empty? flist) '()]
  [else (cons (convertFC (first flist)) (convertFC* (rest flist)))]))
;164
(define EXCHANGE_RATE 0.90) 
(define (convert-euro usd exr)
  (* exr usd))
(define (convert-euro* usdList exr)
  (cond
    [(empty? usdList) '()]
    [else (cons (convert-euro (first usdList) exr) (convert-euro* (rest usdList) exr))]))
;165
(define (substitute new old curr)
  (cond
    [(string=? curr old) new]
    [else curr]))
(define (substitute* new old currList)
  (cond
    [(empty? currList) '()]
    [else (cons (substitute new old (first currList)) (substitute* new old (rest currList)))]))
  