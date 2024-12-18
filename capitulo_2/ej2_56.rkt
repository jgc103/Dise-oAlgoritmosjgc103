#lang racket

;Definimos las funciones necesarias
(define (variable? x) (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1)
       (variable? v2)
       (eq? v1 v2)))

;;; Constructores y selectores para sumas
(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) (+ a1 a2))
        (else (list '+ a1 a2))))

(define (sum? x)
  (and (pair? x) (eq? (car x) '+)))

(define (addend s) (cadr s))
(define (augend s) (caddr s))

(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list '* m1 m2))))

(define (product? x)
  (and (pair? x) (eq? (car x) '*)))

(define (multiplier p) (cadr p))
(define (multiplicand p) (caddr p))


(define (make-exponentiation base exponent)
  (cond ((=number? exponent 0) 1) ; base^0 = 1
        ((=number? exponent 1) base) ; base^1 = base
        ((and (number? base) (number? exponent))
         (expt base exponent)) 
        (else (list '** base exponent))))

(define (exponentiation? x)
  (and (pair? x) (eq? (car x) '**)))

(define (base exp) (cadr exp))
(define (exponent exp) (caddr exp))

(define (=number? exp num)
  (and (number? exp) (= exp num)))

(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp)
         (if (same-variable? exp var) 1 0))
        ((sum? exp)
         (make-sum (deriv (addend exp) var)
                   (deriv (augend exp) var)))
        ((product? exp)
         (make-sum
          (make-product 
           (multiplier exp)
           (deriv (multiplicand exp) var))
          (make-product 
           (deriv (multiplier exp) var)
           (multiplicand exp))))
        ((exponentiation? exp)
         (let ((u (base exp))
               (n (exponent exp)))
           (make-product
            (make-product n
                          (make-exponentiation u (- n 1)))
            (deriv u var))))
        (else (error "unknown expression type: DERIV" exp))))

;;; Ejemplos de uso
(display (deriv '(+ x 3) 'x)) ; Resultado esperado: 1
(newline)

(display (deriv '(* x y) 'x)) ; Resultado esperado: y
(newline)

(display (deriv '(** x 3) 'x)) ; Resultado esperado: (* 3 (** x 2))
(newline)

(display (deriv '(** (+ x 1) 2) 'x)) ; Resultado esperado: (* 2 (+ x 1))
(newline)

(display (deriv '(** (+ (** x 2) x) 3) 'x))
; Resultado esperado: (+ (* 3 (** (+ (** x 2) x) 2) (+ (* 2 x) 1)))
(newline)