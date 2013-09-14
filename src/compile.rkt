#!/usr/bin/env racket
#lang racket
(provide compile)
(require "utils.rkt")
(require "keywords.rkt")
(module+ main
         ;(require rackunit)
         (require racket/trace))

(define (make-indent n)
  (make-string (* n 4) #\ ))

(define (compile fl [indent 0])
  (begin (string-join (map (lambda (x) (compile-expression x indent)) fl) "\n")))

(define (compile-expression fl [indent 0])
  (if (empty? fl)
    ""
    (let
      ([head (car fl)])
      (cond
        [(eq? head KW_PACKAGE) (compile-package (cdr fl) indent)]
        [(eq? head KW_IMPORT) (compile-import (cdr fl) indent)]
        [(eq? head KW_CLASS) (compile-class (cdr fl) indent)]
        [(eq? head KW_CLASS_INIT) (compile-class-init (cdr fl) indent)]
        ;[(eq? head KW_CLASS_METHOD) (compile-class-method (cdr fl) indent)]
        [(eq? head KW_CLASS_VAR) (compile-class-var (cdr fl) indent)]
        [(eq? head KW_DEFINE) (compile-define (cdr fl) indent)]
        [(eq? head KW_VAR) (compile-var (cdr fl) indent)]
        [(eq? head KW_SET!) (compile-set! (cdr fl) indent)]
        [(eq? head KW_SEND) (compile-send (cdr fl) indent)]
        [(eq? head KW_LAMBDA) (compile-lambda (cdr fl) indent)]
        [(eq? head KW_LET) (compile-let (cdr fl) indent)]
        [(eq? head KW_LET*) (compile-let* (cdr fl) indent)]
        [(eq? head KW_IF) (compile-if (cdr fl) indent)]
        [(eq? head KW_COND) (compile-cond (cdr fl) indent)]
        [(arithmatic-operator? head) (compile-arith fl indent)]
        [(boolean-operator? head) (compile-bool fl indent)]
        [else (compile-apply fl indent)]))))

;(func arg1 arg2...)
(define (compile-apply fl [indent 0])
  (if (empty? fl)
    ""
    (let ([func (compile-sub-body (car fl))]
          [argv (cdr fl)])
      (string-append (make-indent indent)
                     func
                     "( "
                     (string-join (map (lambda (x)
                                         (compile-sub-body x indent))
                                       argv)
                                  ", ")
                     " )"))))
(module+ main
         ;(display (compile-expression '((lambda (x y) (+ x y)) 1 2)))
         ;(newline)
         ;(display (compile-expression '(a 1 2 3)))
         ;(newline)
         )
                     

;;;;;;;;;Non-value expression;;;;;;;;;;
;(package package-name ...)
(define (compile-package fl [indent 0])
  (if (not
        (>= (length fl) 1))
    (error "Package expression is invalid!") 
    (let 
      ([package-name (car fl)]) 
      (if (not (symbol? package-name)) 
        (error "Package name invalid!") 
        (string-append (string-append (make-indent indent) 
                                      "package " 
                                      (if (eq? package-name KW_DEFAULT) "" (~s package-name)) 
                                      "{\n")
                       (compile (cdr fl) (+ indent 1))
                       (string-append (make-indent indent) 
                                      "}"))))))
(module+ main
         ;(display (compile-package '(default ())))
         )

;(import package-path)
(define (compile-import fl [indent 0])
  (if (not
        (= (length fl) 1))
    (error "Import expression is invalid!")
    (let
      ([import-name (car fl)]) 
      (string-append (make-indent indent) 
                     "import " 
                     (~s import-name) 
                     ";"))))
(module+ main
         ;(display (compile-expression '(import flash.display.Sprite) 1))
         )

(define (check-class-modifier modifier)
  (cond 
    [(eq? modifier KW_PUBLIC) "public class"]
    [(eq? modifier KW_INNER) "class"]
    [else (error "Class modifier is invalid!")]))
    
;(class public-or-outter super-class class-name ...)
(define (compile-class fl [indent 0])
  (if (not (>= (length fl) 3)) 
    (begin (display fl) (error "Class expression is invalid!"))
    (let 
      ([modifier (car fl)]
       [super-class (cadr fl)]
       [class-name (caddr fl)]
       [body (cdddr fl)])
      (string-append (string-append (make-indent indent)
                                    (check-class-modifier modifier)
                                    " " 
                                    (~s class-name) 
                                    " extends " 
                                    (~s super-class) 
                                    " {\n")
                     (compile body (+ indent 1))
                     (string-append (make-indent indent) "}")))))
(module+ main
         ;(display (compile-expression '(class public Object Test ())))
         )

;(class-init class-name (arg1 arg2 ...) ...)
(define (compile-class-init fl [indent 0])
  (if (not (>= (length fl) 2))
    (error "Class-init is invalid")
    (let ([class-name (car fl)]
          [argv (cadr fl)]
          [body (cddr fl)])
      (string-append (string-append (make-indent indent) 
                                    "public function " 
                                    (~s class-name) 
                                    "( " 
                                    (string-join (map 
                                                   (lambda 
                                                     (arg) 
                                                     (string-append (~s arg) ":*")) 
                                                   argv) 
                                                 ", "))
                                    " ) {\n"
                     (string-append (make-indent (+ 1 indent))
                                    "const self:Object = this;\n")
                     (compile body (+ indent 1))
                     (string-append (make-indent indent) 
                                    "}"
                                    )))))
(module+ main
         ;(display (compile-expression '(class-init Test (a b c)) 1))
         )

;For method body or function body which should have a 'return' expression at last
(define (compile-return-body fl [indent 0])
  (cond [(empty? fl) ""] 
        [(= (length fl) 1) (string-append (make-indent indent) 
                                          "return (" 
                                          (compile-sub-body (car fl) indent)
                                          ");")]
                                        
        [else (string-append (compile-expression (car fl) indent) 
                             "\n" 
                             (compile-return-body (cdr fl) indent))]))
(module+ main
         ;(display (compile-return-body '((define a 12) (define b 3) (+ a b))))
         )

(define (compile-sub-body fl [indent 0])
  (if (list? fl)
    (string-append "\n" (compile-expression fl (+ indent 1)))
    (~s fl)))

;(class-method method-name (arg1 arg2 ...) ...)
(define (compile-class-method fl [indent 0]) 0)

;(class-var variable initial-value)
(define (compile-class-var fl [indent 0])
  (if (not (= (length fl) 2))
    (error "Class-var expression is invalid")
    (let ([variable (car fl)]
          [initial-value (cadr fl)])
      (string-append (make-indent indent)
                     "private var "
                     (~s variable)
                     " :* = "
                     (compile-sub-body initial-value indent)
                     ";"))))

;(define constant value)
(define  (compile-define fl [indent 0])
  (if (not (= (length fl) 2))
    (error "Define expression is invalid")
    (let ([variable (car fl)]
          [initial-value (cadr fl)])
      (string-append (make-indent indent)
                     "const "
                     (~s variable)
                     " :* = "
                     (compile-sub-body initial-value indent)
                     ";"))))

;(var variable initial-value)
(define (compile-var fl [indent 0]) 
  (if (not (= (length fl) 2))
    (error "Var expression is invalid")
    (let ([variable (car fl)]
          [initial-value (cadr fl)])
      (string-append (make-indent indent)
                     "var "
                     (~s variable)
                     " :* = "
                     (compile-sub-body initial-value indent)
                     ";"))))
(module+ main
         ;(display (compile-expression '(class-var a 12) 1))
         ;(display (compile-expression '(var b 12) 1))
         ;(display (compile-expression '(define c 12) 1))
         )

;(set! variable value)
(define (compile-set! fl [indent 0])
  (let ([variable (car fl)]
        [value (cadr fl)])
    (string-append (make-indent indent)
                   (~s variable)
                   " = "
                   (compile-sub-body value indent)
                   ";")))

(module+ main
         (display (compile-expression '(set! a 1)))
         )

;;;;;;;;;;;;;;;;;Value Statement;;;;;;;;;;;;;;;;;;
;(send object method arg1 arg2 ...)
(define (compile-send fl [indent 0]) 
  (if (not (>= (length fl) 2))
    (error "Send expression is invalid")
    (let ([object (car fl)]
          [method (cadr fl)]
          [argv (cddr fl)])
      (string-append (make-indent indent)
                     "("
                     (~s object)
                     "."
                     (~s method)
                     "("
                     (string-join (map (lambda (x)
                                         (compile-sub-body x indent)) 
                                       argv) 
                                  ", ")
                     "))"))))

(module+ main
         ;(display (compile-expression '(send a b 1 (lambda (a b) (+ a 3 b)) 3)))
         )

;(lambda (arg1 arg2...) body)
(define (compile-lambda fl [indent 0])
  (if (not (>= (length fl) 2))
    (error "Lambda expression is invalid! " (~s fl))
    (let ([argv (car fl)]
          [body (cdr fl)])
      (string-append (string-append (make-indent indent)
                                    "(function(" 
                                    (string-join (map (lambda (arg) 
                                                        (string-append (~s arg) ":*")) 
                                                      argv) 
                                                 ", ") 
                                    "):*{\n")
                     (compile-return-body body (+ indent 1))
                     (string-append "\n" 
                                    (make-indent indent)
                                    "})")))))
(module+ main
         ;(display (compile-expression '(lambda (x y) (define c 1) (define b 2) (lambda (m n) (+ x y c b m n)))))
         )

;(let ([local1 value1]...) body)
(define (compile-let fl [indent 0])
  (let ([argv (car fl)]
        [body (cdr fl)])
    (string-append (make-indent indent)
                   "(function("
                   (string-join (map (lambda (x) 
                                       (string-append (~s (car x)) 
                                                      ":*")) 
                                     argv)
                                ", ")
                   
                   "):*{\n"
                   (compile-return-body body (+ indent 1))
                   "\n"
                   (string-append (make-indent indent)
                                  "}("
                                  (string-join (map (lambda (x)
                                                      (compile-sub-body (cadr x) indent))
                                                    argv)
                                               ", ")
                                  "))"))))


(module+ main
         ;(display (compile-expression '(let ([a 1] [b 2]) (+ a b))))
         ;(newline)
         )

;(let* ([local1 value1]...) body)
(define (compile-let* fl [indent 0])
  (let ([argv (car fl)]
        [body (cdr fl)])
    (string-append (make-indent indent)
                   "(function():*{\n"
                   (string-join (map (lambda (x)
                                       (string-append (make-indent (+ 1 indent))
                                                      "var "
                                                      (~s (car x))
                                                      " :* = " 
                                                      (compile-sub-body (cadr x) indent)
                                                      ";\n"))
                                     argv)
                                "")
                   (compile-return-body body (+ indent 1))
                   "\n"
                   (string-append (make-indent indent)
                                  "}())"))))

(module+ main
         ;(display (compile-expression '(let* ([f (lambda (x) (* 2 x))] [y 2]) (lambda (z) (var f (lambda (m) (+ 1 m))) (define a 1) (define b (lambda () "hello")) (+ (f y) z))) ))
         )

;(if condition then else)
(define (compile-if fl [indent 0]) 
  (let ([condition (car fl)]
        [then-clause (cadr fl)]
        [else-clause (caddr fl)])
    (string-append "(function():*{\n" 
                   (make-indent (+ 1 indent)) 
                   "if (" 
                   (compile-sub-body condition (+ 1 indent)) 
                   ") {\n" 
                   (compile-return-body (list then-clause) (+ 1 indent)) 
                   "} else {\n" 
                   (compile-return-body (list else-clause) (+ 1 indent)) 
                   "}}())")))

(module+ main
         ;(display (compile-expression '(if (> 1 2) (+ 3 4) (+ 5 6))))
         )

;(cond [cond1 then1] [cond2 then2] ...)
(define (compile-cond fl [indent 0]) 
  ;[cond value]
  (define (compile-cond-body fl [indent 0])
    (let ([condition (if (eq? (car fl) KW_ELSE)
                       '(= 1 1)
                       (car fl))]
          [value (cadr fl)])
      (string-append (make-indent indent)
                     "if("
                     (compile-sub-body condition (+ 1 indent))
                     "){\n"
                     (compile-return-body (list value) (+ 1 indent))
                     "}")))
  (string-append "(function():*{\n"
                 (string-join (map (lambda (x)
                                     (compile-cond-body x (+ indent 1)))
                                   fl)
                              "\n")
                 "}())"))

(module+ main
         ;(display (compile-expression '(cond [(> 1 2) (+ 1 2)] [(= 1 2) (- 4 5)] [(= 4 5) (* 5 6)] [else (- 0 9)])))
         )

;(op a b c ...)
(define (compile-multiple-operator fl [indent 0])
  (if (not (>= (length fl) 3))
    (error "Multiple operator expression is invalid")
    (let ([op (car fl)]
          [argv (cdr fl)]) 
      (string-append (make-indent indent) 
                     "( " 
                     (string-join (map (lambda (x) 
                                         (compile-sub-body x indent))
                                       argv) 
                                  (string-append " "
                                                 (~s op)
                                                 " ")) 
                     " )"))))
;(op a)
(define (compile-unary-operator fl [indent 0])
  (if (not (= (length fl) 2))
    (error "Unary operator expression is invalid")
    (let ([op (car fl)]
          [arg (cadr fl)])
      (string-append (make-indent indent)
                     "( "
                     (~s op)
                     " "
                     (compile-sub-body arg indent)
                     " )"))))

(define (compile-arith fl [indent 0])
  (compile-multiple-operator fl indent))

(define (compile-bool fl [indent 0])
  (let ([op (car fl)]
        [argv (cadr fl)]) 
    (cond
      [(eq? op KW_NOT) (compile-unary-operator fl indent)]
      [(eq? op KW_EQUAL) (compile-multiple-operator 
                           (cons '== (cdr fl)) 
                           indent)]
      [else (compile-multiple-operator fl indent)])))

(module+ main
         ;(display (compile-expression '(+ 1 (and (> 1 2) (< 2 4) (not (= 1 2)) ) 3 (- 4 5 (* 2 3)) (/ 4 5))))
         )

;(begin body1 body2...)
(define (compile-begin fl [indent 0]) 
  (string-append 
    "(function():*{"
    (compile-return-body fl (+ 1 indent))
    "}())"))


(module+ main
         )

