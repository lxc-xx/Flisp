#!/usr/bin/env racket
#lang racket
(require "core.rkt")
(require "check.rkt")

(provide compile)

(define (compile fl [indent 0])
    (begin (string-join (map (lambda (x) (check-compile x indent)) fl) "\n")))

(define (check-compile fl [indent 0]) 
  (check fl) 
  (compile-expression fl indent))
