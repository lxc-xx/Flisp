#!/usr/bin/env racket
#lang racket
(require "read.rkt")
(require "compile.rkt")
(provide flispc)


(define (flispc argv)
  (if 
    (not (= (vector-length argv) 2))
    (begin (display "Usage: flispc <flisp_source_file> <output_actionscript_file>\n") (exit 1))
    (let* (
           [input-file-path (vector-ref argv 0)]
           [output-file-path (vector-ref argv 1)]
           [fl (read-fl input-file-path)]
           [as (compile fl)]
           )
      (display-to-file as output-file-path #:exists 'replace))))

(module+ main
         (flispc (current-command-line-arguments)))
