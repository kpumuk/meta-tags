# MetaTags: Rails helpers for SEO metadata, sharing, canonical URLs, and robots

[![Tests](https://github.com/kpumuk/meta-tags/actions/workflows/tests.yml/badge.svg)](https://github.com/kpumuk/meta-tags/actions/workflows/tests.yml)
[![Gem Version](https://badge.fury.io/rb/meta-tags.svg)](https://badge.fury.io/rb/meta-tags)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-standard-brightgreen.svg)](https://github.com/testdouble/standard)
[![Gem Downloads](https://img.shields.io/gem/dt/meta-tags.svg)](https://badge.fury.io/rb/meta-tags)
[![Changelog](https://img.shields.io/badge/Changelog-latest-blue.svg)](https://github.com/kpumuk/meta-tags/blob/main/CHANGELOG.md)

MetaTags helps Ruby on Rails applications render HTML head metadata such as titles, descriptions, canonical links, robots directives, Open Graph tags, X card tags, and hreflang links.

It supports the metadata layer of search engine optimization (SEO), especially for titles, descriptions, canonicalization, robots directives, and social sharing previews.

## Ruby on Rails

The MetaTags main branch fully supports Ruby on Rails 6.1+ and is tested against all major Ruby on Rails releases.

> [!NOTE]
> We no longer support Ruby versions older than 3.0 and Ruby on Rails older than 6.1 since they reached their end of life (see [Ruby](https://endoflife.date/ruby) and [Ruby on Rails](https://endoflife.date/rails)).

> [!IMPORTANT]
> MetaTags manages HTML head metadata. It does not generate structured data / JSON-LD, `robots.txt`, sitemaps, internal links, or page content.

## Installation

Add the "meta-tags" gem to your `Gemfile`.

```ruby
gem "meta-tags"
```

And run `bundle install` command.

## Configuration

MetaTags ships with practical defaults for truncation and rendering. You can change them to match your application. Legacy fields such as `keywords` are still supported for compatibility, but they are not modern search requirements.

To override the defaults, create an initializer `config/initializers/meta_tags.rb` using the following command:

```bash
rails generate meta_tags:install
```

When a truncation limit is reached, arrays passed to `title` or `keywords` can
either partially truncate the last item or stop at item boundaries. Set
`config.truncate_array_items_at_boundaries = true` to preserve whole items for
multi-item arrays. Single-item arrays are still truncated normally.

By default, meta tags are rendered with the key `name`. However, some meta tags are required to use `property` instead (like Facebook Open Graph object). The MetaTags gem allows you to configure which tags to render with the `property` attribute. The pre-configured list includes all possible Facebook Open Graph object types by default, but you can add your own in case you need it.

## MetaTags Usage

First, add this code to your main layout:

```erb
<head>
  <%= display_meta_tags site: "My website" %>
</head>
```

Then, to set the page title, add this to each of your views (see below for other options):

```erb
<h1><%= title "My page title" %></h1>
```

When views are rendered, the page title will be included in the right spots:

```html
<head>
  <title>My website | My page title</title>
</head>
<body>
  <h1>My page title</h1>
</body>
```

You can find allowed options for the `display_meta_tags` method below.

> [!IMPORTANT]
> You **must** use `display_meta_tags` in the layout files to render the meta tags. In the views, you will instead use `set_meta_tags`, which accepts the same arguments but does not render anything in the place where it is called.

### Using MetaTags in controller

You can define the following instance variables:

```ruby
@page_title = "Member Login"
@page_description = "Member login page."
```

Also, you could use the `set_meta_tags` method to define all meta tags simultaneously:

```ruby
set_meta_tags(
  title: "Member Login",
  description: "Member login page."
)
```

You can find the allowed options for the `set_meta_tags` method below.

### Using MetaTags in view

To set meta tags, you can use the following methods:

```erb
<% title "Member Login" %>
<% description "Member login page." %>
<% nofollow %>
<% noindex %>
<% refresh 3 %>
```

Also, the `set_meta_tags` method exists:

```erb
<%
  set_meta_tags(
    title: "Member Login",
    description: "Member login page."
  )
%>
```

You can pass an object that implements the `#to_meta_tags` method and returns a Hash:

```ruby
class Document < ApplicationRecord
  def to_meta_tags
    {
      title: title,
      description: summary
    }
  end
end

@document = Document.first
set_meta_tags @document
```

The `title` method returns the title itself, so you can use it to show the title
somewhere on the page:

```erb
<h1><%= title "Member Login" %></h1>
```

If you want to set the title and display another text, use this:

```erb
<h1><%= title "Member Login", "Here you can login to the site:" %></h1>
```

### Allowed options for `display_meta_tags` and `set_meta_tags` methods

Use these options to customize the title format:

| Option         | Description                                                                                                         |
| -------------- | ------------------------------------------------------------------------------------------------------------------- |
| `:site`        | Site title                                                                                                          |
| `:title`       | Page title                                                                                                          |
| `:description` | Page description                                                                                                    |
| `:keywords`    | Legacy keywords meta tag for compatibility; ignored by Google Search and Bing web search                            |
| `:charset`     | Page character set                                                                                                  |
| `:prefix`      | Text between site name and separator                                                                                |
| `:separator`   | Text used to separate the website name from the page title                                                          |
| `:suffix`      | Text between separator and page title                                                                               |
| `:lowercase`   | When true, the page name will be lowercase                                                                          |
| `:reverse`     | When true, the page and site names will be reversed                                                                 |
| `:noindex`     | Add noindex meta tag; when true, "robots" will be used; accepts a string with a robot name or an array of strings   |
| `:index`       | Add index meta tag; when true, "robots" will be used; accepts a string with a robot name or an array of strings     |
| `:nofollow`    | Add nofollow meta tag; when true, "robots" will be used; accepts a string with a robot name or an array of strings  |
| `:follow`      | Add follow meta tag; when true, "robots" will be used; accepts a string with a robot name or an array of strings    |
| `:noarchive`   | Add noarchive meta tag; when true, "robots" will be used; accepts a string with a robot name or an array of strings |
| `:canonical`   | Add canonical link tag                                                                                              |
| `:prev`        | Add legacy prev pagination link tag                                                                                 |
| `:next`        | Add legacy next pagination link tag                                                                                 |
| `:image_src`   | Add legacy image_src share hint                                                                                     |
| `:og`          | Add Open Graph tags (Hash)                                                                                          |
| `:twitter`     | Add Twitter tags (Hash)                                                                                             |
| `:refresh`     | Refresh interval and optionally URL to redirect to                                                                  |

And here are a few examples to give you ideas.

```erb
<%= display_meta_tags separator: "&mdash;".html_safe %>
<%= display_meta_tags prefix: false, separator: ":" %>
<%= display_meta_tags lowercase: true %>
<%= display_meta_tags reverse: true, prefix: false %>
<%= display_meta_tags og: { title: "The Rock", type: "video.movie" } %>
<%= display_meta_tags alternate: { "zh-Hant" => "http://example.com.tw/base/url" } %>
```

### Allowed values

You can specify `:title` as a string or array:

```ruby
set_meta_tags title: ["part1", "part2"], site: "site"
# site | part1 | part2
set_meta_tags title: ["part1", "part2"], reverse: true, site: "site"
# part2 | part1 | site
```

If you still need the legacy `keywords` tag, values can be passed as a string of comma-separated values or as an array:

```ruby
set_meta_tags keywords: ["tag1", "tag2"]
# tag1, tag2
```

The description is a string (HTML will be stripped from the output string).

### Mirrored values

Sometimes, it is desirable to mirror meta tag values down into namespaces. A common use case is when you want the open graph's `og:title` to be identical to the `title`.

Let's say you have the following code in your application layout:

```ruby
display_meta_tags og: {
  title: :title,
  site_name: :site
}
```

The value of `og[:title]` is a symbol, which refers to the value of the top-level `title` meta tag. In any view with the following code:

```ruby
title "my great view"
```

You will get this open graph meta tag automatically:

```html
<meta property="og:title" content="my great view"></meta>
```

> [!NOTE]
> The `title` does not include the site name. If you need to reference the exact value rendered in the `<title>` meta tag, use `:full_title`.

### Using with Turbo

[Turbo](https://github.com/hotwired/turbo) is a simple solution for getting the performance benefits of a single-page application without the added complexity of a client-side JavaScript framework. MetaTags supports Turbo out of the box, so no configuration is necessary.

In order to update the page title, you can use the following trick. First, set the ID for the `<title>` HTML tag using MetaTags configuration in your initializer `config/initializers/meta_tags.rb`:

```ruby
MetaTags.configure do |config|
  config.title_tag_attributes = {id: "page-title"}
end
```

Now in your turbo frame, you can update the title using a turbo stream:

```html
<turbo-frame ...>
  <turbo-stream action="update" target="page-title">
    <template>My new title</template>
  </turbo-stream>
</turbo-frame>
```

### Using with pjax

[jQuery.pjax](https://github.com/defunkt/jquery-pjax) is a nice solution for navigation without a full-page reload. The main difference is that the layout file will not be rendered, so the page title will not change. To fix this, when using a page fragment, pjax will check the fragment DOM element for a `title` or `data-title` attribute and use any value it finds.

MetaTags simplifies this with the `display_title` method, which returns the fully resolved page title (including site, prefix/suffix, etc.). But in this case, you will have to set default parameters (e.g., `:site`) both in the layout file and in your views. To minimize code duplication, you can define a helper in `application_helper.rb`:

```ruby
def default_meta_tags
  {
    title: "Member Login",
    description: "Member login page.",
    separator: "&mdash;".html_safe
  }
end
```

Then, in your layout file, use:

```erb
<%= display_meta_tags(default_meta_tags) %>
```

And in your pjax templates:

```erb
<!-- set title here so we can use it both in "display_title" and in "title" -->
<% title "My Page title" %>
<%= content_tag :div, data: { title: display_title(default_meta_tags) } do %>
    <h1><%= title %></h1>
    <!-- HTML goes here -->
<% end %>
```

## Search and Sharing Metadata

These tags still matter for search snippets, canonicalization, robots directives, and social sharing. They are only one part of modern SEO. You should combine them with good page content, internal links, structured data, sitemaps, and crawl controls where appropriate.

### Titles

Page titles help browsers, social previews, and search engines understand the page. Use unique, descriptive titles that match the visible page content.

```ruby
set_meta_tags title: "Member Login"
# <title>Member Login</title>
set_meta_tags site: "Site Title", title: "Member Login"
# <title>Site Title | Member Login</title>
set_meta_tags site: "Site Title", title: "Member Login", reverse: true
# <title>Member Login | Site Title</title>
```

Google does not publish a fixed title length. Keep titles concise and informative; search results may truncate them based on available width.

Further reading:

- [Title Tag](https://moz.com/learn/seo/title-tag)
- [Google Search Central: title links](https://developers.google.com/search/docs/appearance/title-link)

### Description

Description meta tags help search engines generate snippets, but search engines may also use visible page text instead. Write a short summary that matches the page.

Below is an example of how to set a description tag using Ruby:

```ruby
set_meta_tags description: "This is a sample description"
# <meta name="description" content="This is a sample description">
```

Google does not publish a fixed meta description length. Make the description long enough to be useful and specific, not long enough to hit an arbitrary character count.

Further reading:

- [Meta Description](https://moz.com/learn/seo/meta-description)
- [How Long Should Your Meta Description Be? (2018 Edition)](https://moz.com/blog/how-long-should-your-meta-description-be-2018)
- [Google Search Central: control your snippets in search results](https://developers.google.com/search/docs/appearance/snippet)

### Keywords

The `keywords` tag is a legacy feature. MetaTags still supports it for backwards compatibility and for systems that still read it, but it is not a modern web SEO signal.

```ruby
set_meta_tags keywords: %w[keyword1 keyword2 keyword3]
# <meta name="keywords" content="keyword1, keyword2, keyword3">
```

> [!NOTE]
> Google Search ignores the `keywords` meta tag, and Bing web search has long treated it the same way. Use this tag only if you have your own downstream consumer for it.

Further reading:

- [Google Search Central: meta tags Google supports](https://developers.google.com/search/docs/crawling-indexing/special-tags)

### Noindex

By using the noindex meta tag, you can signal to search engines not to include specific pages in their indexes.

```ruby
set_meta_tags noindex: true
# <meta name="robots" content="noindex">
set_meta_tags noindex: "googlebot"
# <meta name="googlebot" content="noindex">
```

This is useful for pages like login, password reset, cart, account settings, or internal search results.

Further reading:

- [Blocking Google](http://www.google.com/support/webmasters/bin/answer.py?hl=en&answer=93708)
- [Using meta tags to block access to your site](http://www.google.com/support/webmasters/bin/answer.py?hl=en&answer=93710)
- [Google Search Central: robots meta tag and X-Robots-Tag](https://developers.google.com/search/docs/crawling-indexing/robots-meta-tag)

### Index

In most cases, you do not need to emit `index` explicitly because it is already the default for crawlable pages.

```ruby
set_meta_tags index: true
# <meta name="robots" content="index">
```

### Nofollow

Nofollow meta tags tell a search engine not to follow the links on a specific page. It is entirely possible that a robot might find the same links on another page without a nofollow attribute, perhaps on another site, and still arrive at your undesired page.

```ruby
set_meta_tags nofollow: true
# <meta name="robots" content="nofollow">
set_meta_tags nofollow: "googlebot"
# <meta name="googlebot" content="nofollow">
```

Further reading:

- [About rel="nofollow"](http://www.google.com/support/webmasters/bin/answer.py?answer=96569)
- [Meta tags](http://www.google.com/support/webmasters/bin/answer.py?hl=en&answer=79812)
- [Google Search Central: robots meta tag and X-Robots-Tag](https://developers.google.com/search/docs/crawling-indexing/robots-meta-tag)

### Follow

You can use `follow` with `noindex` if you need that combination, but most pages do not need an explicit `follow` tag because it is also the default behavior.

```ruby
set_meta_tags noindex: true, follow: true
# <meta name="robots" content="noindex, follow">
```

This tag will prevent search engines from indexing this specific page, but it will still allow them to crawl and index the remaining pages on your website.

### Canonical URL

Canonical link elements help search engines consolidate duplicate or near-duplicate URLs under one preferred URL. They are a signal, not a guarantee.

> [!NOTE]
> If your goal is duplicate consolidation, prefer a canonical URL over `noindex`. If you do not want to mix canonical with `noindex`, set `MetaTags.config.skip_canonical_links_on_noindex = true`.

```ruby
set_meta_tags canonical: "http://yoursite.com/canonical/url"
# <link rel="canonical" href="http://yoursite.com/canonical/url">
```

Further reading:

- [About rel="canonical"](http://www.google.com/support/webmasters/bin/answer.py?hl=en&answer=139394)
- [Canonicalization](http://www.google.com/support/webmasters/bin/answer.py?hl=en&answer=139066)
- [Google Search Central: canonicalization and duplicate URLs](https://developers.google.com/search/docs/crawling-indexing/consolidate-duplicate-urls)

### Icon

A favicon (short for Favorite icon), also known as a shortcut icon, website icon, tab icon, or bookmark icon, is a file containing one or more small icons, most commonly 16x16 pixels, associated with a particular website or web page.

```ruby
set_meta_tags icon: "/favicon.ico"
# <link rel="icon" href="/favicon.ico" type="image/x-icon">
set_meta_tags icon: "/favicon.png", type: "image/png"
# <link rel="icon" href="/favicon.png" type="image/png">
set_meta_tags icon: [
  {href: "/images/icons/icon_96.png", sizes: "32x32 96x96", type: "image/png"},
  {href: "/images/icons/icon_itouch_precomp_32.png", rel: "apple-touch-icon-precomposed", sizes: "32x32", type: "image/png"}
]
# <link rel="icon" href="/images/icons/icon_96.png" type="image/png" sizes="32x32 96x96">
# <link rel="apple-touch-icon-precomposed" href="/images/icons/icon_itouch_precomp_32.png" type="image/png" sizes="32x32">
```

Further reading:

- [Favicon](https://www.wikiwand.com/en/Favicon)
- [Touch Icons](https://mathiasbynens.be/notes/touch-icons)

### Multi-regional and multilingual URLs, RSS and mobile links

Alternate link elements tell a search engine when there is content that's translated or targeted to users in a certain region.

```ruby
set_meta_tags alternate: {"fr" => "http://yoursite.fr/alternate/url"}
# <link rel="alternate" href="http://yoursite.fr/alternate/url" hreflang="fr">

set_meta_tags alternate: {"fr" => "http://yoursite.fr/alternate/url",
                          "de" => "http://yoursite.de/alternate/url"}
# <link rel="alternate" href="http://yoursite.fr/alternate/url" hreflang="fr">
# <link rel="alternate" href="http://yoursite.de/alternate/url" hreflang="de">
```

If you need more than just multi-lingual links, you can use an alternative syntax:

```ruby
set_meta_tags alternate: [
  {href: "http://example.fr/base/url", hreflang: "fr"},
  {href: "http://example.com/feed.rss", type: "application/rss+xml", title: "RSS"},
  {href: "http://m.example.com/page-1", media: "only screen and (max-width: 640px)"}
]
```

Further reading:

- [Multi-regional and multilingual sites](https://support.google.com/webmasters/answer/182192)
- [About rel="alternate" hreflang="x"](http://www.google.com/support/webmasters/bin/answer.py?hl=en&answer=189077)
- [Separate URLs](https://developers.google.com/webmasters/mobile-sites/mobile-seo/configurations/separate-urls#annotation-in-the-html)

### Pagination links

Previous and next links can describe a paginated sequence for browsers, feed readers, or custom consumers that still read them. Google no longer uses `rel="prev"` and `rel="next"` as an indexing signal, so treat them as optional interoperability metadata, not core SEO guidance.

```ruby
set_meta_tags prev: "http://yoursite.com/url?page=1"
# <link rel="prev" href="http://yoursite.com/url?page=1">
set_meta_tags next: "http://yoursite.com/url?page=3"
# <link rel="next" href="http://yoursite.com/url?page=3">
```

Further reading:

- [Pagination](http://support.google.com/webmasters/bin/answer.py?hl=en&answer=1663744)
- [Pagination with rel="next" and rel="prev"](http://googlewebmastercentral.blogspot.ca/2011/09/pagination-with-relnext-and-relprev.html)
- [Google Search Central: pagination, incremental page loading, and infinite scroll](https://developers.google.com/search/docs/specialty/ecommerce/pagination-and-incremental-page-loading)

### image_src links

`image_src` is a legacy share hint. Modern social sharing generally relies on Open Graph images and platform-specific card tags instead.

```ruby
set_meta_tags image_src: "http://yoursite.com/icons/icon_32.png"
# <link rel="image_src" href="http://yoursite.com/icons/icon_32.png">
```

### amphtml links

If your application still serves AMP pages, you can link the AMP version from the canonical page with `amphtml`. This is an optional legacy integration, not a general SEO requirement.

```ruby
set_meta_tags amphtml: url_for(format: :amp, only_path: false)
# <link rel="amphtml" href="https://www.example.com/document.amp">
```

To link back to the normal version, use the `canonical` tag.

- [AMP documentation](https://amp.dev/documentation/)

### Manifest links

By including the `rel="manifest"` attribute in the `<link>` element of an HTML page, you can specify the location of the manifest file that describes the web application. This allows the browser to understand that the web page is an application and to provide features like offline access and the ability to add the application to the home screen of a mobile device.

```ruby
set_meta_tags manifest: "manifest.json"
# <link rel="manifest" href="manifest.json">
```

- [What is manifest?](https://developer.mozilla.org/en-US/docs/Web/Manifest)

### Refresh interval and redirect URL

Meta refresh is a method of instructing a web browser to automatically refresh the current web page or frame after a given time interval. It is also possible to instruct the browser to fetch a different URL when the page is refreshed, by including the alternative URL in the content parameter. By setting the refresh time interval to zero (or a very low value), this allows meta refresh to be used as a method of URL redirection.

```ruby
set_meta_tags refresh: 5
# <meta content="5" http-equiv="refresh">
set_meta_tags refresh: "5;url=http://example.com"
# <meta content="5;url=http://example.com" http-equiv="refresh">
```

Further reading:

- [Meta refresh](http://en.wikipedia.org/wiki/Meta_refresh)
- [What is the Meta Refresh Tag](http://webdesign.about.com/od/metataglibraries/a/aa080300a.htm)

### Open Search

Open Search is a link element used to describe a search engine in a standard and accessible format.

```ruby
set_meta_tags open_search: {
  title: "Open Search",
  href: "/opensearch.xml"
}
# <link href="/opensearch.xml" rel="search" title="Open Search" type="application/opensearchdescription+xml">
```

Further reading:

- [OpenSearch specs](http://www.opensearch.org/Specifications/OpenSearch/1.1)
- [OpenSearch wiki](http://en.wikipedia.org/wiki/OpenSearch)

### Hashes

Any namespace can be created by simply passing a symbol name and a Hash. For example:

```ruby
set_meta_tags foo: {
  bar: "lorem",
  baz: {
    qux: "ipsum"
  }
}
# <meta property="foo:bar" content="lorem">
# <meta property="foo:baz:qux" content="ipsum">
```

### Arrays

Repeated meta tags can be easily created by using an Array within a Hash. For example:

```ruby
set_meta_tags og: {
  image: ["http://example.com/rock.jpg", "http://example.com/rock2.jpg"]
}
# <meta property="og:image" content="http://example.com/rock.jpg">
# <meta property="og:image" content="http://example.com/rock2.jpg">
```

### Open Graph

To turn your web pages into graph objects, you'll need to add Open Graph protocol `<meta>` tags to your webpages. The tags allow you to specify structured information about your web pages. The more information you provide, the more opportunities your web pages can be surfaced within Facebook today and in the future. Here's an example for a movie page:

```ruby
set_meta_tags og: {
  title: "The Rock",
  type: "video.movie",
  url: "http://www.imdb.com/title/tt0117500/",
  image: "http://ia.media-imdb.com/rock.jpg",
  video: {
    director: "http://www.imdb.com/name/nm0000881/",
    writer: ["http://www.imdb.com/name/nm0918711/", "http://www.imdb.com/name/nm0177018/"]
  }
}
# <meta property="og:title" content="The Rock">
# <meta property="og:type" content="video.movie">
# <meta property="og:url" content="http://www.imdb.com/title/tt0117500/">
# <meta property="og:image" content="http://ia.media-imdb.com/rock.jpg">
# <meta property="og:video:director" content="http://www.imdb.com/name/nm0000881/">
# <meta property="og:video:writer" content="http://www.imdb.com/name/nm0918711/">
# <meta property="og:video:writer" content="http://www.imdb.com/name/nm0177018/">
```

Multiple images declared as an **array** (look at the `_` character):

```ruby
set_meta_tags og: {
  title: "Two structured image properties",
  type: "website",
  url: "view-source:http://examples.opengraphprotocol.us/image-array.html",
  image: [
    {
      _: "http://examples.opengraphprotocol.us/media/images/75.png",
      width: 75,
      height: 75
    },
    {
      _: "http://examples.opengraphprotocol.us/media/images/50.png",
      width: 50,
      height: 50
    }
  ]
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
```

Article meta tags are supported too:

```ruby
set_meta_tags article: {
  published_time: "2013-09-17T05:59:00+01:00",
  modified_time: "2013-09-16T19:08:47+01:00",
  section: "Article Section",
  tag: "Article Tag"
}
# <meta property="article:published_time" content="2013-09-17T05:59:00+01:00">
# <meta property="article:modified_time" content="2013-09-16T19:08:47+01:00">
# <meta property="article:section" content="Article Section">
# <meta property="article:tag" content="Article Tag">
```

Further reading:

- [Open Graph protocol](http://developers.facebook.com/docs/opengraph/)
- [Open Graph protocol](https://ogp.me/)
- [Must-Have Social Meta Tags for Twitter, Google+, Facebook and More](https://moz.com/blog/meta-data-templates-123)
- [X for Websites documentation](https://developer.x.com/en/docs/x-for-websites)

### Twitter Cards

X cards let links shared on X show richer previews. The metadata namespace is still `twitter:*`. Here is a simple summary card example:

```ruby
set_meta_tags twitter: {
  card: "summary",
  site: "@username"
}
# <meta name="twitter:card" content="summary">
# <meta name="twitter:site" content="@username">
```

If you already publish Open Graph tags, you can often keep the X-specific tags minimal. Many consumers fall back to supported Open Graph fields when X-specific fields are missing.

When you need to generate nested `twitter:image:*` tags, the `twitter:image` property is a string while sub-properties can be expressed as a `Hash` in MetaTags:

```ruby
set_meta_tags twitter: {
  card: "summary_large_image",
  image: {
    _: "http://example.com/1.png",
    width: 100,
    height: 100,
    alt: "Cover image"
  }
}
# <meta name="twitter:card" content="summary_large_image">
# <meta name="twitter:image" content="http://example.com/1.png">
# <meta name="twitter:image:width" content="100">
# <meta name="twitter:image:height" content="100">
# <meta name="twitter:image:alt" content="Cover image">
```

A special parameter `itemprop` can be used on an "anonymous" tag "\_" to generate the "itemprop" HTML attribute:

```ruby
set_meta_tags twitter: {
  card: "summary_large_image",
  image: {
    _: "http://example.com/1.png",
    width: 100,
    height: 100,
    alt: "Cover image",
    itemprop: "image"
  }
}
# <meta name="twitter:card" content="summary_large_image">
# <meta name="twitter:image" content="http://example.com/1.png" itemprop="image">
# <meta name="twitter:image:width" content="100">
# <meta name="twitter:image:height" content="100">
# <meta name="twitter:image:alt" content="Cover image">
```

Further reading:

- [X for Websites documentation](https://developer.x.com/en/docs/x-for-websites)

### App Links

App Links is an open cross-platform solution for deep linking to content in your mobile app. Here's an example of iOS app integration:

```ruby
set_meta_tags al: {
  ios: {
    url: "example://applinks",
    app_store_id: 12345,
    app_name: "Example App"
  }
}
# <meta property="al:ios:url" content="example://applinks">
# <meta property="al:ios:app_store_id" content="12345">
# <meta property="al:ios:app_name" content="Example App">
```

Further reading:

- [App Links Documentation](https://developers.facebook.com/docs/applinks)

### Custom meta tags

Starting from version 1.3.1, you can specify arbitrary meta tags, and they will be rendered on the page, even if the meta-tags gem does not know about them.

Example:

```ruby
set_meta_tags author: "Dmytro Shteflyuk"
# <meta name="author" content="Dmytro Shteflyuk">
```

You can also specify the value as an Array, and the values will be displayed as a list of `meta` tags:

```ruby
set_meta_tags author: ["Dmytro Shteflyuk", "John Doe"]
# <meta name="author" content="Dmytro Shteflyuk">
# <meta name="author" content="John Doe">
```

## Maintainers

[Dmytro Shteflyuk](https://github.com/kpumuk), [https://dmytro.sh](https://dmytro.sh)
