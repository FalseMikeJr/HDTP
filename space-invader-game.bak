;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname space-invader-game) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define WIDTH 20)
(define HEIGHT 20)
(define BOARD-SIZE (* WIDTH HEIGHT))
(require 2htdp/batch-io)
(require 2htdp/image)
(require 2htdp/universe)
(define GAME-BOARD (empty-scene BOARD-SIZE BOARD-SIZE))
(define UFO_CIRC 10)
(define UFO_BASE_WIDTH WIDTH)
(define UFO_BASE_HEIGHT 8)
(define UFO (overlay/align "center" "bottom" (rectangle UFO_BASE_WIDTH UFO_BASE_HEIGHT "solid" "grey") (circle UFO_CIRC "solid" "grey")))
(define TANK_BASE_WIDTH 20)
(define ARM_WIDTH 8)
(define TANK_BASE_HEIGHT 12)
(define TANK (overlay/align "center" "bottom" (rectangle ARM_WIDTH TANK_BASE_WIDTH "solid" "red") (rectangle TANK_BASE_WIDTH TANK_BASE_HEIGHT "solid" "red")))
(define MISSILE (overlay/align/offset
                 "center" "top"
                 (rectangle 1 (- HEIGHT (image-height (triangle WIDTH "solid" "red"))) "solid" "green")
                 0 (- HEIGHT (image-height (triangle WIDTH "solid" "red"))) (triangle WIDTH "solid" "red")))
(define UFO_HEIGHT (image-height UFO))
(define UFO_WIDTH (image-width UFO))
(define TANK_HEIGHT (image-height TANK))
(define TANK_WIDTH (image-width TANK))
(define TANK_SPEED 2)
(define TANK_Y (- (image-height GAME-BOARD) (/ TANK_HEIGHT 2)))
(define MISSILE_SPEED -8)
(define UFO_SPEED 2)
;a ufo is a flying object
;a missile is a flying object
;object-collision tells whether it collided with a missile / ufo
(define-struct flying-object [x y object-collision?])
;ufos is one of:
;'()
;(cons flying-object ufos)
;missiles is one of:
;'()
;(cons flying-object missiles)
;sigs ufo-x-dir is a number, 1 => right, -1 => left
(define-struct sigs [ufos missiles tank ufo-x-dir])



;(define-struct aim [ufo tank])
;(define-struct fired [ufo tank missile])
;A ufo is a posn
;(make-posn x y) is the UFO's location
(define-struct tank [loc])
;a tank is a structure:
; (make-tank x dx)
;A missile is a posn
;(make-posn xy) is the missile's location



(define (sigs-render sigsCurr)
  (make-tank-image (sigs-ufos sigsCurr) (sigs-missiles sigsCurr) (tank-loc (sigs-tank sigsCurr))))

(define (make-tank-image ufos missiles tank-x)
  (place-image/align TANK (* WIDTH tank-x) (- (image-height GAME-BOARD) (image-height TANK)) "left" "top" (make-missile-image ufos missiles)))
(define (make-missile-image ufos missiles)
  (place-images/align
   (make-image-array (length missiles) MISSILE) (make-object-posns missiles) "left" "top" (make-ufo-image ufos)))
(define (make-ufo-image ufos)
  (place-images/align
   (make-image-array (length ufos) UFO) (make-object-posns ufos) "left" "top" GAME-BOARD))
(define (make-image-array len img)
  (cond
    [(= len 0) '()]
    [else (cons img (make-image-array (- len 1) img))]))
(define (make-object-posns objects)
  (cond
    [(empty? objects) '()]
    [else (cons
           (make-object-posn (first objects)) (make-object-posns (rest objects)))]))
(define (make-object-posn object)
  (make-posn (* (flying-object-x object) WIDTH) (* (flying-object-y object) HEIGHT)))

(define (sigs-tock sigsCurr)
  (move-new-projectiles
   ;new-ufos
   (remove-collided-projectiles (mark-collided-projectiles (sigs-missiles sigsCurr) (sigs-ufos sigsCurr)))
   ;new-missiles
   (remove-collided-projectiles (mark-collided-projectiles (sigs-ufos sigsCurr) (remove-horizoned-missiles (sigs-missiles sigsCurr))))
   (sigs-tank sigsCurr)
   (sigs-ufo-x-dir sigsCurr)
  )
)
(define (move-new-projectiles uncoll-ufos uncoll-missiles sigsTank oldUfoDir)
  (cond
    [(ufos-wall-collision? uncoll-ufos oldUfoDir)
        (make-sigs
         (move-ufos-down uncoll-ufos)
         (move-missiles uncoll-missiles)
         sigsTank
         (* -1 oldUfoDir))]
    [else
     (make-sigs
      (move-ufos-horiz uncoll-ufos oldUfoDir)
      (move-missiles uncoll-missiles)
      sigsTank
      oldUfoDir)]))
;for tomorrow
(define (move-ufos-down sigsUfos)
  (cond
    [(empty? sigsUfos) '()]
    [else (cons (make-flying-object (flying-object-x (first sigsUfos)) (+ 1 (flying-object-y (first sigsUfos))) (flying-object-object-collision? (first sigsUfos))) (move-ufos-down (rest sigsUfos)))]))
(define (move-ufos-horiz sigsUfos dir)
  (cond
    [(empty? sigsUfos) '()]
    [else (cons (make-flying-object (+ dir (flying-object-x (first sigsUfos))) (flying-object-y (first sigsUfos)) (flying-object-object-collision? (first sigsUfos))) (move-ufos-horiz (rest sigsUfos) dir))]))
(define (move-missiles sigsMissiles)
  (cond
    [(empty? sigsMissiles) '()]
    [else (cons (make-flying-object (flying-object-x (first sigsMissiles)) (- (flying-object-y (first sigsMissiles)) 1) (flying-object-object-collision? (first sigsMissiles))) (move-missiles (rest sigsMissiles)))]))


(define (remove-collided-projectiles sigsProjectile)
  (cond
    [(empty? sigsProjectile) '()]
    [(flying-object-object-collision? (first sigsProjectile)) (remove-collided-projectiles (rest sigsProjectile))]
    [else (cons (first sigsProjectile) (remove-collided-projectiles (rest sigsProjectile)))]))
;marking projectile2, comparing against projectile1
(define (mark-collided-projectiles sigsProjectile1 sigsProjectile2);missiles)
  (cond
    [(empty? sigsProjectile1) sigsProjectile2]
    [(empty? sigsProjectile2) '()]
    [(member? (first sigsProjectile2) sigsProjectile1) (cons (make-collided-flying-object (first sigsProjectile2)) (mark-collided-projectiles sigsProjectile1 (rest sigsProjectile2)))]
    [else (cons (first sigsProjectile2) (mark-collided-projectiles sigsProjectile1 (rest sigsProjectile2)))]))
(define (make-collided-flying-object f-object)
  (make-flying-object (flying-object-x f-object) (flying-object-y f-object) #true))
(define (mark-collided-ufos sigsCurr)
  sigsCurr)
;takes a list of ufos and checks if any collide with wall
(define (ufos-wall-collision? sigsUFOs dir)
  (cond
    [(empty? sigsUFOs) #false]
    [(ufo-wall-collision? (first sigsUFOs) dir) #true]
    [else (ufos-wall-collision? (rest sigsUFOs) dir)]))
;takes a single ufo and checks if it collides with wall
(define (ufo-wall-collision? sigUFO dir)
  (or
   (and (<= (flying-object-x sigUFO) 0) (= dir -1))
   (and (>= (flying-object-x sigUFO) (- WIDTH 1)) (= dir 1))))
(define (remove-horizoned-missiles sigsMissiles)
  (cond
    [(empty? sigsMissiles) '()]
    [(> 0 (flying-object-y (first sigsMissiles))) (remove-horizoned-missiles (rest sigsMissiles))]
    [else (cons (first sigsMissiles) (remove-horizoned-missiles (rest sigsMissiles)))]))

(define (sigs-handle-keys sigsCurr ke)
  (cond
    [(or (string=? ke "left") (string=? ke "right")) (move-tank sigsCurr ke)]
    [(string=? ke " ") (fire-missile sigsCurr)]
    [else sigsCurr]))
(define (move-tank sigsCurr dir)
  (make-sigs
   (sigs-ufos sigsCurr)
   (sigs-missiles sigsCurr)
   (make-tank
    (+ (tank-loc (sigs-tank sigsCurr))
       (cond
         [(and (string=? dir "left") (< 0 (tank-loc (sigs-tank sigsCurr)))) -1]
         [(and (string=? dir "right") (> (- WIDTH 1) (tank-loc (sigs-tank sigsCurr)))) 1]
         [else 0])))
   (sigs-ufo-x-dir sigsCurr)))
(define (fire-missile sigsCurr)
  (make-sigs
   (sigs-ufos sigsCurr)
   (cons (make-flying-object (tank-loc (sigs-tank sigsCurr)) (- HEIGHT 2) #false) (sigs-missiles sigsCurr))
   (sigs-tank sigsCurr)
   (sigs-ufo-x-dir sigsCurr)))
         

(define (end-sigs-state sigsCurr)
  (or (empty? (sigs-ufos sigsCurr))
      (ufo-landed? (sigs-ufos sigsCurr))))
(define (ufo-landed? ufos)
  (cond
    [(empty? ufos) #false]
    [(= (- HEIGHT 1) (flying-object-y (first ufos))) #true]
    [else (ufo-landed? (rest ufos))]))
(define (sigs-render-final sigsCurr)
  (overlay (cond
             [(empty? (sigs-ufos sigsCurr)) (text "You Win!" 18 "green")]
             [else (text "You Lose!" 18 "red")])
           (sigs-render sigsCurr)))

(define simple-sigs
  (make-sigs
   (list
    (make-flying-object 4 0 #false)
    (make-flying-object 6 0 #false)
    (make-flying-object 8 0 #false)
    (make-flying-object 10 0 #false)
    (make-flying-object 12 0 #false)
    (make-flying-object 14 0 #false)
    (make-flying-object 5 1 #false)
    (make-flying-object 7 1 #false)
    (make-flying-object 9 1 #false)
    (make-flying-object 11 1 #false)
    (make-flying-object 13 1 #false)
    (make-flying-object 15 1 #false))
   '()
   (make-tank 4) 1))
(define (main-si ws fr)
  (big-bang ws
    [on-tick sigs-tock fr]
    [on-key sigs-handle-keys]
    [to-draw sigs-render]
    [stop-when end-sigs-state sigs-render-final]
    ))
(main-si simple-sigs .3)