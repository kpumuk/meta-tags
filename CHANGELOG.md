## 2.4.1 (May 15, 2017)

Features:
  - Rails 5.1 support added

## 2.4.0 (December 8, 2016)

Features:
  - Added amphtml links support

Bugfixes:
  - Fixed `place` attribute meta tag generation

## 2.3.1 (September 13, 2016)

Changes:
  - Added follow meta tag support

Features:
  - Added support for article meta tags

Bugfixes:

## 2.2.0 (August 24, 2016)

Changes:

  - Rails < 3.2 is not longer supported

Features:

  - Added support for `<link rel="image_src" href="...">` tag
  - Added support for App Links
  - Added support for `follow` meta tag

Bugfixes:

  - Fixed double escaping for ampersands (thanks to @srecnig)
  - Removed usage of `alias_method_chain` to fix deprecation warnings with Rails 5
  - Fixed the issue when title was truncated in some cases, when site_title was blank
  - Fixed meta tag attributes for `fb:` meta tags

## 2.1.0 (October 6, 2015)

Changes:

  - Ruby < 2.0 is not longer supported

Features:

  - Added charset meta tag
  - Added ability to configure limits for title, description, keywords
  - Added OpenSearch links support
  - Added icon links support
  - Alternate links can now be generated for RSS or mobile versions

Bugfixes
  - Generate `<meta name=""/>` instead of `<meta property=""/>` for custom meta tags
  - Double HTML escaping in meta tags

## 2.0.0 (April 15, 2014)

Features:

  - Fully refactored code base.

Bugfixes:

  - Symlink references in nested hashes include use normalized meta tag values.

## 1.6.0 (April 14, 2014)

Features:

  - Added "alternate" links support
  - Added Google "author" and "publisher" links
  - Implemented mirrored values inside namespaces declared as hashes

Breaking changes:

  - Removed support of Rails older than 3.0.0 due to the bug in `Hash#deep_merge` (does not support `HashWithIndifferentAccess`)

## 1.5.0 (May 7, 2013)

Features:

  - Added "prev" and "next" links support
  - Added refresh meta tag support

## 1.4.1 (March 14, 2013)

Bugfixes:

  - Added support for Hash inside of an Array

## 1.4.0 (March 14, 2013)

Features:

  - Added support of custom meta tags

## 1.3.0 (February 13, 2013)

Features:

  - Added Hash and Array as possible contents for the meta tags. Check README for details
  - Added support of string meta tag names
  - Allow to disable noindex and nofollow using `false` as a value

Bugfixes:

  - Do not display title HTML tag when title is blank
  - Do not display OpenGraph tags when content is empty

## 1.2.6 (March 4, 2012)

Features:

  - jQuery.pjax support via `display_title` method. Check README for details

## 1.2.5 (March 3, 2012)

Bugfixes:

  - Fixed bug with overriding open graph attributes
  - Fixed incorrect page title when `:site` is is blank
  - Normalize `:og` attribute to `:open_graph`

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
