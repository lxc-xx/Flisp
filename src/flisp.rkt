#!/usr/bin/env racket
#lang racket
(require "read.rkt")
(require "compile.rkt")

(define (flisp argv)
  (if 
    (not (= (vector-length argv) 1))
    (error "Usage: flisp.rkt flisp_source_file")
    (let* (
           [fl (read-fl (vector-ref argv 0))]
           [as (compile fl)]
           )
      (display as))))

(module+ main
         (flisp (current-command-line-arguments)))
