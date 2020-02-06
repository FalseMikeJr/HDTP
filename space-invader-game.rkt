;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname space-invader-game) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;277
(require 2htdp/batch-io)
(require 2htdp/image)
(require 2htdp/universe)
(define (main-si fr)
  (local (
          (define WIDTH 20)
          (define HEIGHT 20)
          (define TANK_SPEED 2)
          (define MISSILE_SPEED -8)
          (define UFO_SPEED 2)
          ;a ufo is a flying object
          ;a missile is a flying object
          ;object-collision tells whether it collided with a missile / ufo
          (define-struct flying-object [x y object-collision?])
          ;sigs ufo-x-dir is a number, 1 => right, -1 => left
          (define-struct sigs [ufos missiles tank ufo-x-dir])
          ;A ufo is a posn
          ;(make-posn x y) is the UFO's location
          (define-struct tank [loc])
          ;A missile is a posn
          ;(make-posn xy) is the missile's location
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
          (define (sigs-render sigsCurr)
            (local (
                    (define BOARD-SIZE (* WIDTH HEIGHT))
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
                    (define TANK_Y (- (image-height GAME-BOARD) (/ TANK_HEIGHT 2)))
                    
                    (define (make-tank-image ufos missiles tank-x)
                      (place-image/align TANK (* WIDTH tank-x) (- (image-height GAME-BOARD) (image-height TANK)) "left" "top" (make-non-tank-image missiles MISSILE
                                                                                                                                  (make-non-tank-image ufos UFO GAME-BOARD))))
                    (define (make-non-tank-image img-array IMG scene)
                      (place-images/align
                       (make-image-array (length img-array) IMG) (make-object-posns img-array) "left" "top" scene))
                    (define (make-object-posns objects)
                      (local (
                              (define (make-object-posn object)
                                (make-posn (* (flying-object-x object) WIDTH) (* (flying-object-y object) HEIGHT))))
                        (map make-object-posn objects)))
                    (define (make-image-array len img)
                      (local (
                              (define (img-return n)
                                img))
                        (build-list len img-return))))
              (make-tank-image (sigs-ufos sigsCurr) (sigs-missiles sigsCurr) (tank-loc (sigs-tank sigsCurr)))))
          
          (define (sigs-tock sigsCurr)
            (local (
                    (define (move-new-projectiles uncoll-ufos uncoll-missiles sigsTank oldUfoDir)
                      (cond
                        [(ufos-wall-collision? uncoll-ufos oldUfoDir)
                         (make-sigs
                          (move-flyers-vert uncoll-ufos 1)
                          (move-flyers-vert uncoll-missiles -1)
                          sigsTank
                          (* -1 oldUfoDir))]
                        [else
                         (make-sigs
                          (move-ufos-horiz uncoll-ufos oldUfoDir)
                          (move-flyers-vert uncoll-missiles -1)
                          sigsTank
                          oldUfoDir)]))
                    (define (move-flyers-vert flyers dir)
                      (local (
                              (define (increment-flyer-y flyer)
                                (make-flying-object
                                 (flying-object-x flyer)
                                 (+ dir (flying-object-y flyer))
                                 (flying-object-object-collision? flyer))))
                        (map increment-flyer-y flyers)))
                    (define (move-ufos-horiz sigsUfos dir)
                      (local (
                              (define (increment-ufo-x ufo)
                                (make-flying-object
                                 (+ dir (flying-object-x ufo))
                                 (flying-object-y ufo)
                                 (flying-object-object-collision? ufo))))
                        (map increment-ufo-x sigsUfos)))
                    (define (remove-collided-projectiles sigsProjectile)
                      (cond
                        [(empty? sigsProjectile) '()]
                        [(flying-object-object-collision? (first sigsProjectile)) (remove-collided-projectiles (rest sigsProjectile))]
                        [else (cons (first sigsProjectile) (remove-collided-projectiles (rest sigsProjectile)))]))
                    ;marking projectile2, comparing against projectile1
                    (define (mark-collided-projectiles sigsProjectile1 sigsProjectile2);missiles
                      (local (
                              (define (make-collided-flying-object flyer)
                                (cond
                                  [(member? flyer sigsProjectile1)
                                   (make-flying-object (flying-object-x flyer) (flying-object-y flyer) #true)]
                                  [else flyer])))
                        (cond
                          [(empty? sigsProjectile1) sigsProjectile2]
                          [else (map make-collided-flying-object sigsProjectile2)])))
                    ;takes a list of ufos and checks if any collide with wall
                    (define (ufos-wall-collision? sigsUFOs dir)
                      (local (
                              (define (ufo-wall-collision? ufo)
                                (or
                                 (and (<= (flying-object-x ufo) 0) (= dir -1))
                                 (and (>= (flying-object-x ufo) (- WIDTH 1)) (= dir 1)))))
                        (ormap ufo-wall-collision? sigsUFOs)))
                    (define (remove-horizoned-missiles sigsMissiles)
                      (local (
                              (define (horizoned? missile)
                                (<= 0 (flying-object-y missile))))
                        (filter horizoned? sigsMissiles))))
              (move-new-projectiles
               ;new-ufos
               (remove-collided-projectiles (mark-collided-projectiles (sigs-missiles sigsCurr) (sigs-ufos sigsCurr)))
               ;new-missiles
               (remove-collided-projectiles (mark-collided-projectiles (sigs-ufos sigsCurr) (remove-horizoned-missiles (sigs-missiles sigsCurr))))
               (sigs-tank sigsCurr)
               (sigs-ufo-x-dir sigsCurr))))

          (define (sigs-handle-keys sigsCurr ke)
            (local (
                    (define (move-tank dir)
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
                       (sigs-ufo-x-dir sigsCurr))))
              (cond
                [(or (string=? ke "left") (string=? ke "right")) (move-tank ke)]
                [(string=? ke " ") (fire-missile sigsCurr)]
                [else sigsCurr])))
          (define (end-sigs-state sigsCurr)
            (local (
                    (define (ufo-landed? flyer)
                      (= (- HEIGHT 1) (flying-object-y flyer))))
              (cond
                [(empty? (sigs-ufos sigsCurr)) #true]
                [else (ormap ufo-landed? (sigs-ufos sigsCurr))])))
          
          (define (sigs-render-final sigsCurr)
            (overlay (cond
                       [(empty? (sigs-ufos sigsCurr)) (text "You Win!" 18 "green")]
                       [else (text "You Lose!" 18 "red")])
                     (sigs-render sigsCurr))))
          
    (big-bang simple-sigs
      [on-tick sigs-tock fr]
      [on-key sigs-handle-keys]
      [to-draw sigs-render]
      [stop-when end-sigs-state sigs-render-final])))

(main-si .3)