#lang racket

(define (cons x y) 
  (lambda (m) (m x y)))

(define (car z) 
  (z (lambda (p q) p)))

(define (cdr z)
  (z (lambda (p q) q)))

(define a (cons 3 2))    
(cdr a)    