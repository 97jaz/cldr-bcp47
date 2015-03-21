#lang racket/base

(require racket/contract/base
         racket/match
         racket/runtime-path
         racket/string
         xml
         xml/path)

(provide/contract
 [bcp47-timezone-ids      (-> (listof string?))]
 [tzid->bcp47-timezone-id (-> string? (or/c string? #f))]
 [bcp47-timezone-id->tzid (-> string? (or/c string? #f))]
 [bcp47-canonical-tzid    (-> string? (or/c string? #f))])

(define (bcp47-timezone-ids)
  (hash-keys BY-BCP47-ID))

(define (tzid->bcp47-timezone-id id)
  (define z (hash-ref BY-IANA-ID id #f))
  (and z (bcp47-timezone-id z)))

(define (bcp47-timezone-id->tzid id)
  (define z (hash-ref BY-BCP47-ID id #f))
  (and z (car (bcp47-timezone-aliases z))))

(define (bcp47-canonical-tzid id)
  (define z (hash-ref BY-IANA-ID id #f))
  (and z (car (bcp47-timezone-aliases z))))

(struct bcp47-timezone (id aliases desc) #:transparent)

(define-runtime-path XML-PATH "data/timezone.xml")

(define (init)
  (call-with-input-file* XML-PATH
    (λ (in)
      (define doc (read-xml in))
      (define exp (xml->xexpr (document-element doc)))
      (define zones
        (filter pair?
                (se-path*/list '(keyword key) exp)))
      (for ([zone (in-list zones)])
        (match zone
          [(list _ (list-no-order `(name ,id) `(description ,desc) rest ...))
           (define aliases
             (match rest
               [(list-no-order `(alias ,alias-string) _ ...)
                (string-split alias-string)]
               [_ '()]))
           (define z (bcp47-timezone (string->immutable-string id)
                                     (map string->immutable-string aliases)
                                     (string->immutable-string desc)))
           (hash-set! BY-BCP47-ID (bcp47-timezone-id z) z)
           
           (for ([alias (in-list aliases)])
             (hash-set! BY-IANA-ID alias z))])))))

(define BY-BCP47-ID (make-hash))
(define BY-IANA-ID (make-hash))

(init)
