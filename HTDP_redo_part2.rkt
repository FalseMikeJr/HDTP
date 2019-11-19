;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname HTDP_redo_part2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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
;;152
;(define (col n img)
;  (cond
;    [(= 1 n) img]
;    [else (above img (col (sub1 n) img))]))
;(define (row n img)
;  (cond
;    [(= 1 n) img]
;    [else (beside img (row (sub1 n) img))]))
;;153
;
;(define LECTURE_HALL
;  (place-image (col 18 (row 8 (rectangle 10 10 "outline" "black"))) 40 90 (empty-scene 80 180)))
;(define (add-balloons lop)
;  (cond
;    [(empty? lop) LECTURE_HALL]
;    [else (place-image (circle 2 "solid" "red") (posn-x (first lop)) (posn-y (first lop)) (add-balloons (rest lop)))]))
;(define-struct pair [balloon# lob])
;(define (riot w0)
;  
;  (big-bang (make-pair w0 '())
;    [to-draw render_riot]
;    [on-tick tock_riot]
;    ))
;(define (tock_riot p)
;  (cond
;    [(<= (pair-balloon# p) 0) p]
;    [else (make-pair (sub1 (pair-balloon# p)) (cons (make-posn (random 80) (random 180)) (pair-lob p)))]))
;(define (render_riot p)
;  (add-balloons (pair-lob p)))
    
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

;(define HEIGHT 80)
;(define WIDTH 100)
;(define XSHOTS (/ WIDTH 2))
;(define BACKGROUND (empty-scene WIDTH HEIGHT))
;(define SHOT (triangle 6 "solid" "red"))
;; A List-of-shots is one of: 
;; – '()
;; – (cons Shot List-of-shots)
;; interpretation the collection of shots fired
;; shot = a number representing the shot's y coordinate
;
;(define (to-image w)
;  (cond
;    [(empty? w) BACKGROUND]
;    [else
;     (place-image SHOT XSHOTS (first w) (to-image (rest w)))]))
;(define (tock w)
;  (cond
;    [(empty? w) '()]
;    [else
;     (cons (sub1 (first w)) (tock (rest w)))]))
;(define (keyh w ke)
;  (if (key=? ke " ") (cons HEIGHT w) w))
;(define (main w0)
;  (big-bang w0
;    [on-tick tock_2]
;    [on-key keyh]
;    [to-draw to-image]))
;;156
;(check-expect (to-image (cons 9 (cons 10 '())))
;              (place-image SHOT XSHOTS 9 (place-image SHOT XSHOTS 10 BACKGROUND)))
;(check-expect (tock (cons 9 (cons 10 '())))
;              (cons 8 (cons 9 '())))
;(check-expect (keyh (cons 9 (cons 10 '())) " ")
;              (cons HEIGHT (cons 9 (cons 10 '()))))
;;158
;(define (tock_2 w)
;  (cond
;    [(empty? w) '()]
;    [else
;     (cond [(> (first w) 0) (cons (sub1 (first w)) (tock_2 (rest w)))]
;           [else (tock_2 (rest w))])]))
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

;;161, 162
;(define SET_WAGE 14)
;; List-of-numbers -> List-of-numbers
;; computes the weekly wages for all given weekly hours
;(define (wage* whrs)
;  (cond
;    [(empty? whrs) '()]
;    [(<= 100 (first whrs)) (error "hours worked exceed 100")]
;    [else (cons (wage (first whrs)) (wage* (rest whrs)))]))
; 
;; Number -> Number
;; computes the wage for h hours of work
;(define (wage h)
;  (* SET_WAGE h))
;(check-expect (wage* (cons 28 '())) (cons (* 28 SET_WAGE) '()))
;
;;163
;(define (convertFC f)
;  (/ (*(- f 32) 5) 9))
;(define (convertFC* flist)
;  (cond
;  [(empty? flist) '()]
;  [else (cons (convertFC (first flist)) (convertFC* (rest flist)))]))
;;164
;(define EXCHANGE_RATE 0.90) 
;(define (convert-euro usd exr)
;  (* exr usd))
;(define (convert-euro* usdList exr)
;  (cond
;    [(empty? usdList) '()]
;    [else (cons (convert-euro (first usdList) exr) (convert-euro* (rest usdList) exr))]))
;;165
;(define (substitute new old curr)
;  (cond
;    [(string=? curr old) new]
;    [else curr]))
;(define (substitute* new old currList)
;  (cond
;    [(empty? currList) '()]
;    [else (cons (substitute new old (first currList)) (substitute* new old (rest currList)))]))
;
;(define-struct work [employee rate hours])
;;A (piece of) Work is a structure:
;;    (make-work string number number)
;;LOW (list of workers) is one of:
;; -'()
;; -(cons Work Low)
;(define (wage.v2 w)
;  (* (work-hours w) (work-rate w)))
;
;(define (wage*.v2 low)
;  (cond
;    [(empty? low) '()]
;    [(<= 100 (work-hours (first low))) (error "hours worked exceed 100")]
;    [else (cons (wage.v2 (first low)) (wage*.v2 (rest low)))]))
;
;;166
;(define-struct paycheck [employee money])
;(define (wage.v3 w)
;  (make-paycheck (work-employee w) (* (work-rate w) (work-hours w))))
;(define (wage*.v3 low)
;  (cond
;    [(empty? low) '()]
;    [(<= 100 (work-hours (first low))) (error "hours worked exceed 100")]
;    [else (cons (wage.v3 (first low)) (wage*.v3 (rest low)))]))
;
;;167
;(define (sum lop)
;  (cond
;    [(empty? lop) 0]
;    [else (+ (posn-x (first lop)) (sum (rest lop)))]))
;;168
;(define (translate lop)
;  (cond
;    [(empty? lop) '()]
;    [else (cons (make-posn (posn-x (first lop)) (+ (posn-y (first lop)) 1)) (translate (rest lop)))]))
;;169
;(define (legal lop)
;  (cond
;    [(empty? lop) '()]
;    [(legal-helper (first lop)) (cons (first lop) (rest lop))]
;    [else (legal (rest lop))]))
;
;(define (legal-helper p)
;  (and (< (posn-x p) 100) (> (posn-x p) 0) (< (posn-y p) 200) (> (posn-y p) 0)))
;
;;170
;(define-struct phone [area switch four])
;(define (replace lo-phones)
;  (cond
;    [(empty? lo-phones) '()]
;    [(= (phone-area (first lo-phones)) 713) (cons
;                                             (make-phone 281 (phone-switch (first lo-phones)) (phone-four (first lo-phones)))
;                                             (replace (rest lo-phones)))]
;    [else (cons (first lo-phones) (replace (rest lo-phones)))]))
;;171
;;a list of strings is one of:
;;'()
;;(cons string ALOS)
;(cons "TTT" (cons "Put up in a plce" (cons "where it's easy to see" (cons "the cryptic admonishment" (cons "T.T.T." (cons "When you feel how depressingly" (cons "slowly you climb," (cons "it's well to remember that" (cons "Things Take Time." (cons "Piet Hein" '()))))))))))
;
;;a list of list of strings is one of:
;;'()
;; (cons ALOS ALOLOS)
;
;(cons
; (cons "Put" (cons "up" (cons "in" (cons "a" (cons "place" '())))))
; (cons
;  (cons "where" (cons "it's" (cons "easy" (cons "to" (cons "see" '())))))
;  (cons
;   (cons "the" (cons "cryptic" (cons "admonishment" '())))
;   (cons
;    (cons "T.T.T." '())
;    (cons
;     (cons "When" (cons "you" (cons "feel" (cons "how" (cons "depressingly" '())))))
;     (cons
;      (cons "slowly" (cons "you" (cons "climb" '())))
;      (cons
;       (cons "it's" (cons "well" (cons "to" (cons "remember" (cons "that" '())))))
;       (cons
;        (cons "things" (cons "take" (cons "time" '()))) '()))))))))
;(define (words-on-line lls)
;  (cond
;    [(empty? lls) '()]
;    [else
;     (cons (count-words (first lls))
;           (words-on-line (rest lls)))]))
;(define (count-words ls)
;  (cond
;   [(empty? ls) 0]
;   [else (+ 1 (count-words (rest ls)))]))
;
;;172
;(define (collapse lls)
;  (cond
;    [(empty? lls) ""]
;    [else
;     (string-append (collapse-line (first lls))
;           (collapse (rest lls)))]))
;
;(define (collapse-line ls)
;  (cond
;    [(empty? ls) "\n"]
;    [else (string-append (first ls) " " (collapse-line (rest ls)))]))
;
;;173
;;n is file name
;(define (remove-articles-base n)
;  (write-file (string-append "no-articles-" n)
;              (remove-articles (read-words/line n))))
;
;(define (remove-articles lls)
;  (cond
;   [(empty? lls) ""]
;   [else (string-append (remove-articles-helper (first lls)) "\n" (remove-articles (rest lls)))]))
;
;(define (remove-articles-helper ls)
;  (cond
;    [(empty? ls) "\n"]
;    [(or (string=? "a" (first ls)) (string=? "an" (first ls)) (string=? "the" (first ls))) (remove-articles-helper (rest ls))]
;    [else (string-append (first ls) " " (remove-articles-helper (rest ls)))]))
;
;;174
;;n is file name
;(define (encode-text-base n)
;  (write-file (string-append "encoded-text-" n)
;              (encode-text (read-words/line n))))
;
;(define (encode-text lls)
;  (cond
;    [(empty? lls) ""]
;    [else (string-append (encode-text-line (first lls)) (encode-text (rest lls)))]))
;
;(define (encode-text-line ls)
;  (cond
;    [(empty? ls) "\n"]
;    [else (string-append (encode-text-word (explode (first ls))) (encode-text-line (rest ls)))]))
;(define (encode-text-word lw)
;  (cond
;    [(empty? lw) " "]
;    [else (string-append (encode-letter (first lw)) (encode-text-word (rest lw)))]))
;
;; 1String -> String
;; converts the given 1String to a 3-letter numeric String
;(define (encode-letter s)
;  (cond
;    [(>= (string->int s) 100) (code1 s)]
;    [(< (string->int s) 10)
;     (string-append "00" (code1 s))]
;    [(< (string->int s) 100)
;     (string-append "0" (code1 s))]))
; 
;; 1String -> String
;; converts the given 1String into a String
; 
;(check-expect (code1 "z") "122")
; 
;(define (code1 c)
;  (number->string (string->int c)))
;
;;175
;;count of letters, words, lines in a file
;(define-struct strCount [letters words lines])
;
;;consider making a function which sums everything into a single number, then work on separating those sums into a structure
;(define (wc-base n)
;  (wc (read-words/line n)))
;(define (wc lls)
;  (cond
;    [(empty? lls) 0]
;    [else (+ 1 (wc-word (first lls)) (wc (rest lls)))]))
;
;(define (wc-word ls)
;  (cond
;    [(empty? ls) 0]
;    [else (+ 1 (wc-letter (explode (first ls))) (wc-word (rest ls)))]))
;(define (wc-letter s)
;  (cond
;    [(empty? s) 0]
;    [else (+ 1 (wc-letter (rest s)))]))
;;using actual structure
;(define (wc-base2 n)
;  (make-strCount
;   (wc-word2 (read-words n))
;   (length (read-words n))
;   (length (read-lines n))))
;(define (wc-word2 ls)
;  (cond
;    [(empty? ls) 0]
;    [else (+ (string-length (first ls)) (wc-word2 (rest ls)))]))
;
;;176
;; A Matrix is one of: 
;;  – (cons Row '())
;;  – (cons Row Matrix)
;; constraint all rows in matrix are of the same length
; 
;; A Row is one of: 
;;  – '() 
;;  – (cons Number Row)
;(define row1 (cons 11 (cons 12 '())))
;(define row2 (cons 21 (cons 22 '())))
;(define mat1 (cons row1 (cons row2 '())))
;(define (transpose lln)
;  (cond
;    [(empty? (first lln)) '()]
;    [else (cons (first* lln) (transpose (rest* lln)))]))
;
;(define (first* mat)
;  (cond
;    [(empty?  mat) '()]
;    [else (cons (first-row-item (first mat)) (first* (rest mat)))]))
;
;(define (first-row-item row)
;  (first row))
;
;(define (rest* mat)
;  (cond
;    [(empty? mat) '()]
;    [else (cons (last-row-item (first mat)) (rest* (rest mat)))]))
;(define (last-row-item row)
;  (rest row))

(define-struct editor [pre post])
;an editor is one of:
;() or (make-editor 1String Lo1S)

(define (rev l)
  (cond
    [(empty? l) '()]
    [else (add-at-end (rev (rest l)) (first l))]))

(define (add-at-end l s)
  (cond
    [(empty? l) (cons s '())]
    [else (cons (first l)
               (add-at-end (rest l) s))]))
;(rev (cons "a" (cons "b" (cons "c" '()))))
;177
(define (create-editor s1 s2)
  (make-editor s1 s2))

(define HEIGHT 20)
(define WIDTH 200)
(define FONT-SIZE 16)
(define FONT-COLOR "black")
(define MT (empty-scene WIDTH HEIGHT))
(define CURSOR (rectangle 1 HEIGHT "solid" "red"))
(define (editor-kh ed ke)
  (cond
    [(key=? ke "left") (editor-lft ed)]
    [(key=? ke "right") (editor-rgt ed)]
    [(key=? ke "\b") (editor-del ed)]
    [(key=? ke "\t") ed]
    [(key=? ke "\r") ed]
    [(= (string-length ke) 1) (editor-ins ed ke)]
    [else ed]))
;wish-list for this function:
;get-first -- inherent to data structure 
;get-last
;remove-first --inherent to the data structure
;remove-last
;add-to-front -- inherent to data structure
;add-to-back --add-at-end above
;179
(define (editor-lft ed)
  (make-editor
   (remove-last (editor-pre ed))
   (cons (get-last (editor-pre ed)) (editor-post ed))))

(define (editor-rgt ed)
  (make-editor
   (add-at-end (editor-pre ed) (first (editor-post ed)))
   (rest (editor-post ed))))

(define (editor-del ed)
  (make-editor
   (remove-last (editor-pre ed))
   (editor-post ed)))

(define (editor-ins ed ke)
  (make-editor
   (add-at-end (editor-pre ed) ke) (editor-post ed)))

(define (get-last l)
  (cond
    [(empty? (rest l)) (first l)]
    [else (get-last (rest l))]))

(define (remove-last l)
  [cond
    [(empty? (rest l)) '()]
    [else (cons (first l) (remove-last (rest l)))]])

(define (editor-render e)
  (beside (editor-text (editor-pre e)) CURSOR (editor-text (editor-post e))))

(define (editor-text s)
  (text (implode s) FONT-SIZE FONT-COLOR))
;ex 180
(define (editor-text2 s)
  (text (text-concat s) FONT-SIZE FONT-COLOR))
(define (text-concat s)
  (cond
    [(empty? s) ""]
    [else (string-append (first s) (text-concat (rest s)))]))

(define (main s)
  (big-bang (create-editor s "")
    [on-key editor-kh]
    [to-draw editor-render]))

(define ed1 (make-editor (cons "a" (cons "b" (cons "c" '()))) (cons "d" '())))

