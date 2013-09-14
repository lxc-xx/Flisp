#!/usr/bin/env racket
#lang racket
(require "utils.rkt")

(provide (all-defined-out))
;;;;Non-value statement keywords;;;;
(define KW_PACKAGE 'package);done
(define KW_DEFAULT 'default);done
(define KW_PUBLIC 'public);done
(define KW_PRIVATE 'private)
(define KW_STAIC 'static)
(define KW_INNER 'inner);done
(define KW_IMPORT 'import);done
(define KW_CLASS 'class);done
(define KW_CLASS_INIT 'class-init);done
(define KW_CLASS_METHOD 'class-method)
(define KW_CLASS_VAR 'class-var);done
(define KW_DEFINE 'define);done
(define KW_VAR 'var);done
(define KW_SET! 'set!);done
(define KEYWORDS_NON_VALUE
  (list KW_PACKAGE
        KW_DEFAULT
        KW_PUBLIC
        KW_STATIC
        KW_PRIVATE
        KW_INNER
        KW_IMPORT
        KW_CLASS
        KW_CLASS_INIT
        KW_CLASS_METHOD
        KW_CLASS_VAR
        KW_DEFINE
        KW_VAR
        KW_SET!))
(define (non-value-keyword? kw)
  (make-boolean (member kw KEYWORDS_NON_VALUE)))

;;;;Value statement keywords;;;;
;;Constructive statement keywords;;
(define KW_SEND 'send);done
(define KW_LAMBDA 'lambda);done
(define KW_LET 'let);done
(define KW_LET* 'let*);done
(define KW_IF 'if);done
(define KW_ELSE 'else);done
(define KW_COND 'cond);done
(define KW_BEGIN 'begin);done
(define CONSTRUCTIVE_KEYWORDS
  (list KW_SEND
        KW_LAMBDA
        KW_LET
        KW_LET
        KW_IF 
        KW_ELSE
        KW_COND
        KW_BEGIN))
(define (constructive-keyword? op)
  (make-boolean (member op CONSTRUCTIVE_KEYWORDS)))


;;Arithmatic operator
(define KW_ADD '+)
(define KW_MINUS '-)
(define KW_MULTIPLY '*)
(define KW_DIVIDE '/)
(define KW_REMAINDER '%)
(define ARITHMATIC_OPERATORS;done
  (list KW_ADD
        KW_MINUS
        KW_MULTIPLY
        KW_DIVIDE
        KW_REMAINDER))

(define (arithmatic-operator? op)
  (make-boolean (member op ARITHMATIC_OPERATORS)))

(module+ main
         ;(display (arithmatic? '+))
         )

;;Boolean operator
(define KW_AND 'and)
(define KW_OR 'or)
(define KW_NOT 'not)
(define KW_LARGER_THAN '>)
(define KW_LARGER_EQUAL_THAN '>=)
(define KW_SMALLER_THAN '<)
(define KW_SMALLER_EQUAL_THAN '<=)
(define KW_EQUAL '=)
(define BOOLEAN_OPERATORS;done
  (list KW_AND
        KW_OR
        KW_NOT
        KW_LARGER_THAN
        KW_LARGER_EQUAL_THAN
        KW_SMALLER_THAN
        KW_SMALLER_EQUAL_THAN
        KW_EQUAL))
(define (boolean-operator? op)
  (make-boolean (member op BOOLEAN_OPERATORS)))

;;Built-in function
(define KW_CONS 'cons)
(define KW_CAR 'car)
(define KW_CDR 'cdr)
(define KW_PAIR? 'pair?)
(define KW_LIST 'list)
(define KW_LIST? 'list?)
(define KW_EMPTY? 'empty?)
(define KW_MAP 'map)
(define KW_FILTER 'filter)
(define KW_REDUCE 'reduce)
(define KW_RANGE 'range)
(define BUILT_IN_FUNCTIONS
  (list KW_CONS 
        KW_CAR
        KW_CDR
        KW_PAIR?
        KW_LIST
        KW_LIST?
        KW_EMPTY?
        KW_MAP
        KW_FILTER
        KW_REDUCE
        KW_RANGE))
(define (built-in-function? f)
  (make-boolean (member f BUILT_IN_FUNCTIONS)))

(define KEYWORDS_VALUE
  (append CONSTRUCTIVE_KEYWORDS
          BOOLEAN_OPERATORS 
          BUILT_IN_FUNCTIONS
          ARITHMATIC_OPERATORS))

(define KEY_WORDS
  (append KEYWORDS_NON_VALUE
          KEYWORDS_VALUE))

(module+ main)
