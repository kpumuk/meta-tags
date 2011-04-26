# MetaTags: a gem to make your Rails application SEO-friendly

Search Engine Optimization (SEO) plugin for Ruby on Rails applications.

## Rails 3

MetaTags master branch now fully supports Rails 3 and is backward
compatible.

## Installation

Add the "meta-tags" gem to your `Gemfile`.

    gem 'meta-tags', :require => 'meta_tags'

And run `bundle install` command.

## SEO Basics and MetaTags

### Titles

Page titles are very important for Search engines. The titles in the
browser are displayed in the title bar. The search engines would look at
the this title bar to determine what the page is all about.

    set_meta_tags :title => 'Member Login'
    # <title>Some Page Title</title>
    set_meta_tags :site => 'Site Title', :title => 'Member Login'
    # <title>Site Title | Page Title</title>
    set_meta_tags :site => 'Site Title', :title => 'Member Login', :reverse => true
    # <title>Page Title | Site Title</title>

Recommended title tag length: up to <b>70 characters</b>, <b>10 words</b>.

### Description

Description tags are called meta tags as they are not displayed by the
browsers as that of titles. But these descriptions may be displayed by
some search engines. They are used to describe the contents of a page in
2 or 3 sentences.

    set_meta_tags :description => "All text about keywords, other keywords"
    # <meta name="description" content="All text about keywords, other keywords" />

Recommended description tag length: up to <b>160 characters</b>.

### Keywords

Meta keywords tag are used to place your keywords that you think a
surfer would search in Search engines. Repeating keywords unnecessarily
would be considered spam and you may get permanently banned from SERP's

    set_meta_tags :keywords => %w[keyword1 Keyword2 KeyWord3]
    # <meta name="keywords" content="keyword1, keyword2, keyword3" />

Recommended keywords tag length: up to <b>255 characters</b>, <b>20 words</b>.

### Noindex

By using the noindex meta tag, you can signal to search engines to not 
include specific pages in their indexes.

    set_meta_tags :noindex => true
    # <meta name="robots" content="noindex" />
    set_meta_tags :noindex => 'googlebot'
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

    set_meta_tags :nofollow => true
    # <meta name="robots" content="nofollow" />
    set_meta_tags :nofollow => 'googlebot'
    # <meta name="googlebot" content="nofollow" />

Further reading:

* [About rel="nofollow"](http://www.google.com/support/webmasters/bin/answer.py?answer=96569)
* [Meta tags](http://www.google.com/support/webmasters/bin/answer.py?hl=en&answer=79812)

### Canonical URL

Canonical link element tells a search engine what is the canonical or main URL
for a content which have multiple URLs. The search engine will always return
that URL, and link popularity and authority will be applied to that URL.

    set_meta_tags :canonical => "http://yoursite.com/canonical/url"
    # <link rel="canonical" href="http://yoursite.com/canonical/url" />

Further reading:

* [About rel="canonical"](http://www.google.com/support/webmasters/bin/answer.py?hl=en&answer=139394)
* [Canonicalization](http://www.google.com/support/webmasters/bin/answer.py?hl=en&answer=139066)

### Open Graph

To turn your web pages into graph objects, you'll need to add Open Graph
protocol `<meta>` tags to your webpages. The tags allow you to specify
structured information about your web pages. The more information you provide, the more opportunities your web pages can be surfaced within Facebook today
and in the future. Here's an example for a movie page:

    set_meta_tags :open_graph => {
      :title => 'The Rock',
      :type  => :movie,
      :url   => 'http://www.imdb.com/title/tt0117500/',
      :image => 'http://ia.media-imdb.com/rock.jpg'
    }
    # <meta property="og:title" content="The Rock"/>
    # <meta property="og:type" content="movie"/>
    # <meta property="og:url" content="http://www.imdb.com/title/tt0117500/"/>
    # <meta property="og:image" content="http://ia.media-imdb.com/rock.jpg"/>

Further reading:

* [Open Graph protocol](http://developers.facebook.com/docs/opengraph/)

## MetaTags Usage

First, add this code to your main layout:

    <head>
      <%= display_meta_tags :site => 'My website' %>
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
  
    set_meta_tags :title => 'Member Login',
                  :description => 'Member login page.',
                  :keywords => 'Site, Login, Members'

You can find allowed options for `set_meta_tags` method below.

### Using MetaTags in view

To set meta tags you can use following methods:

    <% title 'Member Login' %>
    <% description 'Member login page.' %>
    <% keywords 'Member login page.' %>

Also there is `set_meta_tags` method exists:

    <% set_meta_tags :title => 'Member Login',
                     :description => 'Member login page.',
                     :keywords => 'Site, Login, Members' %>

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
* `:prefix` — text between site name and separator;
* `:separator` — text used to separate website name from page title;
* `:suffix` — text between separator and page title;
* `:lowercase` — when true, the page name will be lowercase;
* `:reverse` — when true, the page and site names will be reversed;
* `:noindex` — add noindex meta tag; when true, 'robots' will be used, otherwise the string will be used;
* `:nofollow` — add nofollow meta tag; when true, 'robots' will be used, otherwise the string will be used;
* `:canonical` — add canonical link tag;
* `:open_graph` — add Open Graph tags (Hash).

And here are a few examples to give you ideas.

    <%= display_meta_tags :separator => "&mdash;".html_safe %>
    <%= display_meta_tags :prefix => false, :separator => ":" %>
    <%= display_meta_tags :lowercase => true %>
    <%= display_meta_tags :reverse => true, :prefix => false %>
    <%= display_meta_tags :open_graph => { :title => 'The Rock', :type => 'movie' } %>

### Allowed values

You can specify `:title` as a string or array:

    set_meta_tags :title => ['part1', 'part2'], :site => 'site'
    # site | part1 | part2
    set_meta_tags :title => ['part1', 'part2'], :reverse => true, :site => 'site'
    # part2 | part1 | site

Keywords can be passed as string of comma-separated values, or as an array:

    set_meta_tags :keywords => ['tag1', 'tag2']
    # tag1, tag2

Description is a string (HTML will be stripped from output string).

## Alternatives

There are several plugins influenced me to create this one:

* [Headliner](https://github.com/mokolabs/headliner)
* [meta\_on_rals](https://github.com/ashchan/meta_on_rails)

## Credits

* [Dmytro Shteflyuk](https://github.com/kpumuk) (author)
* [Morgan Roderick](https://github.com/mroderick) (contributor)
* [Jesse Clark](https://github.com/jesseclark) (contributor)
* Sergio Cambra (contributor)
* Kristoffer Renholm (contributor)
