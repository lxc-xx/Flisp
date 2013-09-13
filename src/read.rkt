#!/usr/bin/env racket
#lang racket
(provide read-fl)

(define (read-fl file_path)
  (read-rec (open-input-file file_path)))


(define (read-rec in)
  (let ([l (read in)])
    (if (eof-object? l)
      '()
      (cons l (read-rec in)))))

