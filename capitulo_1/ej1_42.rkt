#lang racket
(define (inc x) (+ x 1))

(define (compose f g)
  (lambda (x)
    (f (g x))))

(define (square x) (* x x))

((compose square inc) 6)   ; -> 49