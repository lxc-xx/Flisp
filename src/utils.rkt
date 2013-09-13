#!/usr/bin/env racket
#lang racket

(provide make-boolean)
(provide error)
(provide warning)
(provide debug)

(define error (lambda msg 
                (begin (map display msg) (newline) (exit 1))))
(module+ main
         ;(error "12" "23")
         )

(define debug (lambda msg
                (display (string-append (string-join (map (lambda (x)
                                                            (string-append "[DEBUG]: "
                                                                           (~a x)
                                                                           "\n"))
                                                          msg) "")))))

(module+ main
         ;(debug "hello" 1 "world")
         )

(define (warning msg)
  (begin (display msg)
         (newline)
         ))


(define (make-boolean v)
  (not (not v)))

(module+ main
         (require rackunit)
         (check-equal? (make-boolean "hello") #t)
         (check-equal? (make-boolean '()) #t)
         (check-equal? (make-boolean 0) #t)
         (check-equal? (make-boolean (list 1 2 )) #t)
         )
