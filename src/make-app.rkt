#!/usr/bin/env racket
#lang racket

(define (html-string app_name)
  (string-append "<html>\n"
                 " <body>\n"
                 " <object height='100%' width='100%'>\n"
                 "  <embed src='"
                 (string-append app_name ".swf")
                 "' height='100%' width='100%'/>\n"
                 " </object>\n"
                 " </body>\n"
                 "</html>\n"))

(module+ main
         ;(display (html-string "Test.swf"))
         )

(define (app-name path)
  (let* ([file_name (file-name-from-path path)])
    (list-ref (string-split (path->string file_name) ".") 0)))


(require racket/file)

(define (make-app argv)
  (if (not (= (vector-length argv) 2))
    (begin (display "Usage: make-app <main_as_file> <output_directory>\n") (exit 1))
    (let* ([main_as_path (vector-ref argv 0)] 
           [app_name (app-name main_as_path)]
           [bin_path (vector-ref argv 1)] 
           [command (string-append "mxmlc " 
                                   main_as_path 
                                   " --output " 
                                   (string-append bin_path
                                                  "/"
                                                  app_name
                                                  ".swf"))] 
           [html-path (string-append bin_path 
                                      "/index.html")]) 
      (begin (make-directory* bin_path) 
             (system command) 
             (display-to-file (html-string app_name) html-path #:exists 'replace)))))

(module+ main
         (make-app (current-command-line-arguments)))
