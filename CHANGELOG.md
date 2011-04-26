## 1.2.4 (April 26, 2011)

Features:

  - Added support for Open Graph meta tags

Bugfixes:

  - Fixed bug with double HTML escaping in title separator
  - Allow to set meta title without a separator

## 1.2.2, 1.2.3 (June 10, 2010)

Bugfixes:

  - Fixed action\_pack integration (welcome back `alias_method_chain`)
  - Fixed bug when `@page_*` variables did not work

## 1.2.1 (June 2, 2010)

Bugfixes:

  - Fixed deprecation warning about `html_safe!`

## 1.2.0 (May 31, 2010)

Bugfixes:

  - Fixed bug when title is set through Array, and `:lowercase` is true
  - Updated `display_meta_tags` to be compatible with rails_xss

## 1.1.1 (November 21, 2009)

Features:

  - Added support for canonical link element
  - Added YARD documentation

## 1.1.0 (November 5, 2009)

Features:

  - Added ability to specify title as an Array of parts
  - Added helper for `noindex`
  - Added `nofollow` meta tag support

Bugfixes:

  - Fixed Rails 2.3 deprecation warnings
