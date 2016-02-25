# MetaTags: a gem to make your Rails application SEO-friendly

[![Travis-CI build status](https://secure.travis-ci.org/kpumuk/meta-tags.svg)](http://travis-ci.org/kpumuk/meta-tags)
[![Gem Version](https://badge.fury.io/rb/meta-tags.svg)](http://badge.fury.io/rb/meta-tags)
[![Code Climate](https://codeclimate.com/github/kpumuk/meta-tags.png)](https://codeclimate.com/github/kpumuk/meta-tags)
[![Coverage](https://codeclimate.com/github/kpumuk/meta-tags/coverage.png)](https://codeclimate.com/github/kpumuk/meta-tags)

Search Engine Optimization (SEO) plugin for Ruby on Rails applications.

## Ruby on Rails

MetaTags master branch now fully supports Rails 3.0+ and is not backward
compatible. Latest version fully compatible with 2.x is 1.2.3.

Ruby versions older than 2.0.0 are no longer officially supported.

## Installation

Add the "meta-tags" gem to your `Gemfile`.

    gem 'meta-tags'

And run `bundle install` command.

## Configuration

MetaTags follows best-practices for meta tags. Although default limits for
truncation have recommended values, you can change them to reflect your own
preferences. In order to do that, you can create an initializer
`config/initializers/meta_tags.rb`, with following code:

    MetaTags.configure do |c|
      c.title_limit        = 70
      c.description_limit  = 160
      c.keywords_limit     = 255
      c.keywords_separator = ', '
    end

## SEO Basics and MetaTags

### Titles

Page titles are very important for Search engines. The titles in the
browser are displayed in the title bar. The search engines would look at
the this title bar to determine what the page is all about.

    set_meta_tags title: 'Member Login'
    # <title>Some Page Title</title>
    set_meta_tags site: 'Site Title', title: 'Member Login'
    # <title>Site Title | Page Title</title>
    set_meta_tags site: 'Site Title', title: 'Member Login', reverse: true
    # <title>Page Title | Site Title</title>

Recommended title tag length: up to <b>70 characters</b>, <b>10 words</b>.

### Description

Description tags are called meta tags as they are not displayed by the
browsers as that of titles. But these descriptions may be displayed by
some search engines. They are used to describe the contents of a page in
2 or 3 sentences.

    set_meta_tags description: "All text about keywords, other keywords"
    # <meta name="description" content="All text about keywords, other keywords" />

Recommended description tag length: up to <b>160 characters</b>.

### Keywords

Meta keywords tag are used to place your keywords that you think a
surfer would search in Search engines. Repeating keywords unnecessarily
would be considered spam and you may get permanently banned from SERP's

    set_meta_tags keywords: %w[keyword1 Keyword2 KeyWord3]
    # <meta name="keywords" content="keyword1, keyword2, keyword3" />

Recommended keywords tag length: up to <b>255 characters</b>, <b>20 words</b>.

### Noindex

By using the noindex meta tag, you can signal to search engines to not
include specific pages in their indexes.

    set_meta_tags noindex: true
    # <meta name="robots" content="noindex" />
    set_meta_tags noindex: 'googlebot'
    # <meta name="googlebot" content="noindex" />

This is useful for pages like login, password reset, privacy policy, etc.

Further reading:

* [Blocking Google](http://www.google.com/support/webmasters/bin/answer.py?hl=en&answer=93708)
* [Using meta tags to block access to your site](http://www.google.com/support/webmasters/bin/answer.py?hl=en&answer=93710)

### Nofollow

Nofollow meta tag tells a search engine not to follow the links on a specific
page. It's entirely likely that a robot might find the same links on some
other page without a nofollow (perhaps on some other site), and so
still arrives at your undesired page.

    set_meta_tags nofollow: true
    # <meta name="robots" content="nofollow" />
    set_meta_tags nofollow: 'googlebot'
    # <meta name="googlebot" content="nofollow" />

Further reading:

* [About rel="nofollow"](http://www.google.com/support/webmasters/bin/answer.py?answer=96569)
* [Meta tags](http://www.google.com/support/webmasters/bin/answer.py?hl=en&answer=79812)

### Canonical URL

Canonical link element tells a search engine what is the canonical or main URL
for a content which have multiple URLs. The search engine will always return
that URL, and link popularity and authority will be applied to that URL.

    set_meta_tags canonical: "http://yoursite.com/canonical/url"
    # <link rel="canonical" href="http://yoursite.com/canonical/url" />

Further reading:

* [About rel="canonical"](http://www.google.com/support/webmasters/bin/answer.py?hl=en&answer=139394)
* [Canonicalization](http://www.google.com/support/webmasters/bin/answer.py?hl=en&answer=139066)

### Icon

A favicon (short for Favorite icon), also known as a shortcut icon, Web site
icon, tab icon or bookmark icon, is a file containing one or more small icons,
most commonly 16×16 pixels, associated with a particular website or web page.

    set_meta_tags icon: '/favicon.ico'
    # <link rel="icon" href="/favicon.ico" type="image/x-icon" />
    set_meta_tags icon: '/favicon.png', type: 'image/png'
    # <link rel="icon" href="/favicon.png" type="image/png" />
    set_meta_tags icon: [
      { href: '/images/icons/icon_96.png', sizes: '32x32 96x96', type: 'image/png' },
      { href: '/images/icons/icon_itouch_precomp_32.png', rel: 'apple-touch-icon-precomposed', sizes: '32x32', type: 'image/png' },
    ]
    # <link rel="icon" href="/images/icons/icon_96.png" type="image/png" sizes="32x32 96x96" />
    # <link rel="apple-touch-icon-precomposed" href="/images/icons/icon_itouch_precomp_32.png" type="image/png" sizes="32x32" />

Further reading:

* [Favicon](https://www.wikiwand.com/en/Favicon)
* [Touch Icons](https://mathiasbynens.be/notes/touch-icons)

### Author links

Link to your Google+ profile using rel="author"

    set_meta_tags author: "http://yourgplusprofile.com/profile/url"
    # <link rel="author" href="http://yourgplusprofile.com/profile/url" />

Further reading:

* [About rel="author"](https://support.google.com/webmasters/answer/2539557?hl=en)

### Publisher links

Link to your Google+ profile using rel="publisher"

    set_meta_tags publisher: "http://yourgplusprofile.com/profile/url"
    # <link rel="publisher" href="http://yourgplusprofile.com/profile/url" />

* [Link to your website](https://support.google.com/plus/answer/1713826?hl=en)
* [The Difference Between rel=author & rel=publisher](http://www.websitemagazine.com/content/blogs/posts/archive/2013/02/05/the-difference-between-rel-author-amp-rel-publisher.aspx)

### Multi-regional and multilingual URLs, RSS and mobile links

Alternate link elements tell a search engine when there is content that's
translated or targeted to users in a certain region.

    set_meta_tags alternate: { "fr" => "http://yoursite.fr/alternate/url" }
    # <link rel="alternate" href="http://yoursite.fr/alternate/url" hreflang="fr" />

    set_meta_tags alternate: { "fr" => "http://yoursite.fr/alternate/url",
                               "de" => "http://yoursite.de/alternate/url" }
    # <link rel="alternate" href="http://yoursite.fr/alternate/url" hreflang="fr" />
    # <link rel="alternate" href="http://yoursite.de/alternate/url" hreflang="de" />

If you need more than just multi-lingual links, you can use an alternative syntax:

    set_meta_tags alternate: [
        { href: 'http://example.fr/base/url', hreflang: 'fr' },
        { href: 'http://example.com/feed.rss', type: 'application/rss+xml', title: 'RSS' },
        { href: 'http://m.example.com/page-1', media: 'only screen and (max-width: 640px)'},
      ]

Further reading:

* [Multi-regional and multilingual sites](https://support.google.com/webmasters/answer/182192)
* [About rel="alternate" hreflang="x"](http://www.google.com/support/webmasters/bin/answer.py?hl=en&answer=189077)
* [Separate URLs](https://developers.google.com/webmasters/mobile-sites/mobile-seo/configurations/separate-urls#annotation-in-the-html)

### Pagination links

Previous and next links indicate indicate the relationship between individual
URLs. Using these attributes is a strong hint to Google that you want us to
treat these pages as a logical sequence.

    set_meta_tags prev: "http://yoursite.com/url?page=1"
    # <link rel="prev" href="http://yoursite.com/url?page=1" />
    set_meta_tags next: "http://yoursite.com/url?page=3"
    # <link rel="next" href="http://yoursite.com/url?page=3" />

Further reading:

* [Pagination](http://support.google.com/webmasters/bin/answer.py?hl=en&answer=1663744)
* [Pagination with rel="next" and rel="prev"](http://googlewebmastercentral.blogspot.ca/2011/09/pagination-with-relnext-and-relprev.html)

### image_src links

Basically, when you submit/share this to Facebook , this helps Facebook determine which image to put next to the link. If this is not present, Facebook tries to put in the first image it finds on the page, which may not be the best one to represent your site.

    set_meta_tags image_src: "http://yoursite.com/icons/icon_32.png"
    # <link rel="image_src" href="http://yoursite.com/icons/icon_32.png" />

### Refresh interval and redirect URL

Meta refresh is a method of instructing a web browser to automatically
refresh the current web page or frame after a given time interval. It is also
possible to instruct the browser to fetch a different URL when the page is
refreshed, by including the alternative URL in the content parameter. By
setting the refresh time interval to zero (or a very low value), this allows
meta refresh to be used as a method of URL redirection.

    set_meta_tags refresh: 5
    # <meta content="5" http-equiv="refresh" />
    set_meta_tags refresh: '5;url=http://example.com'
    # <meta content="5;url=http://example.com" http-equiv="refresh" />

Further reading:

* [Meta refresh](http://en.wikipedia.org/wiki/Meta_refresh)
* [What is the Meta Refresh Tag](http://webdesign.about.com/od/metataglibraries/a/aa080300a.htm)


### Open Search

Open Search link element to describe a search engine in a standard and accessible format.

    set_meta_tags open_search: {
      title: "Open Search",
      href:  "/opensearch.xml"
    }
    # <link href="/opensearch.xml" rel="search" title="Open Search" type="application/opensearchdescription+xml" />

Further reading:

* [OpenSearch specs](http://www.opensearch.org/Specifications/OpenSearch/1.1)
* [OpenSearch wiki](http://en.wikipedia.org/wiki/OpenSearch)

### Hashes

Any namespace can be built just passing any symbol name and a Hash. For example:

    set_meta_tags foo: {
      bar: "lorem",
      baz: {
        qux: "ipsum"
      }
    }
    # <meta property="foo:bar" content="lorem"/>
    # <meta property="foo:baz:qux" content="ipsum"/>

### Arrays

Repeated meta tags can be built just using an Array inside a Hash. For example:

    set_meta_tags og: {
        image: ["http://example.com/rock.jpg", "http://example.com/rock2.jpg"]
    }
    #<meta property="og:image" content="http://example.com/rock.jpg" />
    #<meta property="og:image" content="http://example.com/rock2.jpg" />

### Open Graph

To turn your web pages into graph objects, you'll need to add Open Graph
protocol `<meta>` tags to your webpages. The tags allow you to specify
structured information about your web pages. The more information you provide, the more opportunities your web pages can be surfaced within Facebook today
and in the future. Here's an example for a movie page:

    set_meta_tags og: {
      title:    'The Rock',
      type:     'video.movie',
      url:      'http://www.imdb.com/title/tt0117500/',
      image:    'http://ia.media-imdb.com/rock.jpg',
      video:    {
        director: 'http://www.imdb.com/name/nm0000881/',
        writer:   ['http://www.imdb.com/name/nm0918711/', 'http://www.imdb.com/name/nm0177018/']
      }
    }
    # <meta property="og:title" content="The Rock"/>
    # <meta property="og:type" content="video.movie"/>
    # <meta property="og:url" content="http://www.imdb.com/title/tt0117500/"/>
    # <meta property="og:image" content="http://ia.media-imdb.com/rock.jpg"/>
    # <meta property="og:video:director" content="http://www.imdb.com/name/nm0000881/"/>
    # <meta property="og:video:writer" content="http://www.imdb.com/name/nm0918711/"/>
    # <meta property="og:video:writer" content="http://www.imdb.com/name/nm0177018/"/>

Multiple images declared as an **array** (look at the `_` character):

    set_meta_tags og: {
      title:    'Two structured image properties',
      type:     'website',
      url:      'view-source:http://examples.opengraphprotocol.us/image-array.html',
      image:    [{
        _: 'http://examples.opengraphprotocol.us/media/images/75.png',
        width: 75,
        height: 75,
      },
      {
        _: 'http://examples.opengraphprotocol.us/media/images/50.png',
        width: 50,
        height: 50,
      }]
    }
    # <meta property="og:title" content="Two structured image properties">
    # <meta property="og:type" content="website">
    # <meta property="og:url" content="http://examples.opengraphprotocol.us/image-array.html">
    # <meta property="og:image" content="http://examples.opengraphprotocol.us/media/images/75.png">
    # <meta property="og:image:width" content="75">
    # <meta property="og:image:height" content="75">
    # <meta property="og:image" content="http://examples.opengraphprotocol.us/media/images/50.png">
    # <meta property="og:image:width" content="50">
    # <meta property="og:image:height" content="50">

Further reading:

* [Open Graph protocol](http://developers.facebook.com/docs/opengraph/)

### Twitter Cards

Twitter cards make it possible for you to attach media experiences to Tweets that link to your content.
There are 3 card types (summary, photo and player). Here's an example for summary:

    set_meta_tags twitter: {
      card: "summary",
      site: "@username"
    }
    # <meta name="twitter:card" content="summary"/>
    # <meta name="twitter:site" content="@username"/>

Take in consideration that if you're already using OpenGraph to describe data on your page, it’s easy to generate a Twitter card without duplicating your tags and data. When the Twitter card processor looks for tags on your page, it first checks for the Twitter property, and if not present, falls back to the supported Open Graph property. This allows for both to be defined on the page independently, and minimizes the amount of duplicate markup required to describe your content and experience.

When you need to generate a [Twitter Photo card](https://dev.twitter.com/docs/cards/types/photo-card), `twitter:image` property is a string, while image dimensions are specified using `twitter:image:width` and `twitter:image:height`, or a `Hash` objects in terms of MetaTags gems. There is a special syntax to make this work:

    set_meta_tags twitter: {
      card:  "photo",
      image: {
        _:      "http://example.com/1.png",
        width:  100,
        height: 100,
      }
    }
    # <meta name="twitter:card" content="photo"/>
    # <meta name="twitter:image" content="http://example.com/1.png"/>
    # <meta name="twitter:image:width" content="100"/>
    # <meta name="twitter:image:height" content="100"/>

Further reading:

* [Twitter Cards Documentation](https://dev.twitter.com/docs/cards/)

### Custom meta tags

Starting from version 1.3.1, you can specify arbitrary meta tags, and they will
be rendered on the page, even if meta-tags gem does not know about them.

Example:

    set_meta_tags author: "Dmytro Shteflyuk"
    # <meta name="author" content="Dmytro Shteflyuk"/>

You can also specify value as an Array, and values will be displayed as a list
of `meta` tags:

    set_meta_tags author: [ "Dmytro Shteflyuk", "John Doe" ]
    # <meta name="author" content="Dmytro Shteflyuk"/>
    # <meta name="author" content="John Doe"/>

## MetaTags Usage

First, add this code to your main layout:

    <head>
      <%= display_meta_tags site: 'My website' %>
    </head>

Then, to set the page title, add this to each of your views (see below for other options):

    <h1><%= title 'My page title' %></h1>

When views are rendered, the page title will be included in the right spots:

    <head>
      <title>My website | My page title</title>
    </head>
    <body>
      <h1>My page title</h1>
    </body>

You can find allowed options for `display_meta_tags` method below.

### Using MetaTags in controller

You can define following instance variables:

    @page_title       = 'Member Login'
    @page_description = 'Member login page.'
    @page_keywords    = 'Site, Login, Members'

Also you could use `set_meta_tags` method to define all meta tags simultaneously:

    set_meta_tags title: 'Member Login',
                  description: 'Member login page.',
                  keywords: 'Site, Login, Members'

You can find allowed options for `set_meta_tags` method below.

### Using MetaTags in view

To set meta tags you can use following methods:

    <% title 'Member Login' %>
    <% description 'Member login page.' %>
    <% keywords 'Member login page.' %>
    <% nofollow %>
    <% noindex %>
    <% refresh 3 %>

Also there is `set_meta_tags` method exists:

    <% set_meta_tags title: 'Member Login',
                     description: 'Member login page.',
                     keywords: 'Site, Login, Members' %>

The `title` method returns title itself, so you can use it to show the title
somewhere on the page:

    <h1><%= title 'Member Login' %></h1>

If you want to set the title and display another text, use this:

    <h1><%= title 'Member Login', 'Here you can login to the site:' %></h1>

### Allowed options for `display_meta_tags` and `set_meta_tags` methods

Use these options to customize the title format:

* `:site` — site title;
* `:title` — page title;
* `:description` — page description;
* `:keywords` — page keywords;
* `:charset` — page character set;
* `:prefix` — text between site name and separator;
* `:separator` — text used to separate website name from page title;
* `:suffix` — text between separator and page title;
* `:lowercase` — when true, the page name will be lowercase;
* `:reverse` — when true, the page and site names will be reversed;
* `:noindex` — add noindex meta tag; when true, 'robots' will be used, otherwise the string will be used;
* `:nofollow` — add nofollow meta tag; when true, 'robots' will be used, otherwise the string will be used;
* `:canonical` — add canonical link tag;
* `:author` — add author link tag;
* `:publisher` — add publisher link tag;
* `:prev` — add prev link tag;
* `:next` — add next link tag;
* `:image_src`  — add image_src link tag;
* `:og` — add Open Graph tags (Hash);
* `:twitter` — add Twitter tags (Hash);
* `:refresh` — refresh interval and optionally url to redirect to.

And here are a few examples to give you ideas.

    <%= display_meta_tags separator: "&mdash;".html_safe %>
    <%= display_meta_tags prefix: false, separator: ":" %>
    <%= display_meta_tags lowercase: true %>
    <%= display_meta_tags reverse: true, prefix: false %>
    <%= display_meta_tags og: { title: 'The Rock', type: 'video.movie' } %>
    <%= display_meta_tags alternate: { 'zh-Hant' => 'http://example.com.tw/base/url' } %>

### Allowed values

You can specify `:title` as a string or array:

    set_meta_tags title: ['part1', 'part2'], site: 'site'
    # site | part1 | part2
    set_meta_tags title: ['part1', 'part2'], reverse: true, site: 'site'
    # part2 | part1 | site

Keywords can be passed as string of comma-separated values, or as an array:

    set_meta_tags keywords: ['tag1', 'tag2']
    # tag1, tag2

Description is a string (HTML will be stripped from output string).

### Mirrored values

Sometimes, it is desirable to mirror meta tag values down into namespaces. A
common use case is when you want open graph's `og:title` to be identical to
the `title`.

Say, you have the following in your application layout:

    display_meta_tags og: {
      title: :title
    }

The value of `og[:title]` is a symbol and therefore references the value of the
top level `title` meta tag. With the following in any view:

    title 'my great view'

You get this open graph meta tag for free:

    <meta property="og:title" content="my great view"></meta>

### Using with pjax

[jQuery.pjax](https://github.com/defunkt/jquery-pjax) is a nice solution for navigation
without full page reload. The main difference is that layout file will not be rendered,
so page title will not change. To fix this, when using a page fragment, pjax will check
the fragment DOM element for a `title` or `data-title` attribute and use any value it finds.

MetaTags simplifies this with `display_title` method, which returns fully resolved
page title (include site, prefix/suffix, etc.) But in this case you will have to
set default parameters (e.g, `:site`) both in layout file and in your views. To minimize
code duplication, you can define a helper in `application_helper.rb`:

    def default_meta_tags
      {
        title:       'Member Login',
        description: 'Member login page.',
        keywords:    'Site, Login, Members',
        separator:   "&mdash;".html_safe,
      }
    end

Then in your layout file use:

    <%= display_meta_tags(default_meta_tags) %>

And in your pjax templates:

    <!-- set title here, so we can use it both in "display_title" and in "title" %>
    <% title "My Page title" %>
    <%= content_tag :div, data: { title: display_title(default_meta_tags) } do %>
        <h1><%= title %></h1>
        <!-- HTML goes here -->
    <% end %>

## Author

[Dmytro Shteflyuk](https://github.com/kpumuk), [http://kpumuk.info](http://kpumuk.info/)
