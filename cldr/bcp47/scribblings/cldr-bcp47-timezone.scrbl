#lang scribble/manual

@(require scribble/eval
          (for-label racket/base
                     racket/runtime-path
                     cldr/bcp47/timezone
                     json))
@(define the-eval (make-base-eval))
@(the-eval '(require cldr/bcp47/timezone))

@title{CLDR BCP47 Time Zone Data}
@author[@author+email["Jon Zeppieri" "zeppieri@gmail.com"]]

@margin-note{
@deftech{CLDR} is the @link["http://cldr.unicode.org/"]{Common Locale Data Repository}, a
database of localization information published by the Unicode Consortium.
}

The CLDR BCP47 Timezone library is a Racket high-level interface to the
@link["http://unicode.org/repos/cldr/trunk/common/bcp47/timezone.xml"]{timezone.xml}
file published by the Unicode Consortium as part of CLDR. Unlike most of the packages in
the @tt{cldr} collection, this one is not based on a JSON data set, because the
data isn't available as JSON.


@defmodule[cldr/bcp47/timezone]

@defproc[(bcp47-timezone-ids) (listof string?)]{
Returns a list of all the BCP47 time zone IDs.
}

@defproc[(tzid->bcp47-timezone-id [tzid string?]) (or/c string? #f)]{
Returns the BCP47 time zone ID correspondng to the given @racket[tzid], which
is an Olson/IANA-style time zone ID. If there is no corresponding ID, @racket[#f]
is returned.

@examples[#:eval the-eval
(tzid->bcp47-timezone-id "America/New_York")
(tzid->bcp47-timezone-id "Fillory/Whitespire")
]}

@defproc[(bcp47-timezone-id->tzid [bcpid string?]) (or/c string? #f)]{
Returns the Olson/IANA-style time zone ID corresponding to @racket[bcpid],
which is a BCP47 time zone identifier. If there is no correspondng ID, @racket[#f]
is returned.

@examples[#:eval the-eval
(bcp47-timezone-id->tzid "uslax")
(bcp47-timezone-id->tzid "abcde")
]}

@defproc[(bcp47-canonical-tzid [tzid string?]) (or/c string? #f)]{
Returns the canonical form (according to BCP47) of the given Olson/IANA-style time zone ID.
If there is no canonical version of @racket[tzid] then @racket[#f] is returned.

@examples[#:eval the-eval
(bcp47-canonical-tzid "US/Eastern")
(bcp47-canonical-tzid "Brazil/Acre")
]}
