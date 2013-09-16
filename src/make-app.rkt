#!/usr/bin/env racket
#lang racket

(define (html-string app_name)
  (string-append "<html>\n"
                 " <body>\n"
                 " <object height='100%' width='100%'>\n"
                 "  <embed src='"
                 app_name
                 "' height='100%' width='100%'/>\n"
                 " </object>\n"
                 " </body>\n"
                 "</html>\n"))
(define (make-index-html app_name bin_path)

(module+ main
         (display (html-string "Test.swf"))
         )

(define (app-name main_as_path)
  (


(require racket/file)
(define (make-app main_as_path bin_path)
  (let ([command (string-append "mxmlc "
                                main_as_path
                                " --output"
                                bin_path)])
    (begin (create-directory* bin_path) 
           (if (system command) 
             (
  
  

