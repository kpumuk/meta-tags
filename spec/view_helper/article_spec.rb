require "spec_helper"

describe MetaTags::ViewHelper, "displaying Article meta tags" do
  subject { ActionView::Base.new }

  it "displays meta tags specified with :article" do
    subject.set_meta_tags(article: { author: "https://www.facebook.com/facebook" })
    subject.display_meta_tags(site: "someSite").tap do |meta|
      expect(meta).to have_tag("meta", with: { content: "https://www.facebook.com/facebook", property: "article:author" })
    end
  end

  it "uses deep merge when displaying open graph meta tags" do
    subject.set_meta_tags(article: { author: "https://www.facebook.com/facebook" })
    subject.display_meta_tags(article: { publisher: "https://www.facebook.com/Google/" }).tap do |meta|
      expect(meta).to have_tag("meta", with: { content: "https://www.facebook.com/facebook", property: "article:author" })
      expect(meta).to have_tag("meta", with: { content: "https://www.facebook.com/Google/", property: "article:publisher" })
    end
  end

  it "does not display meta tags without content" do
    subject.set_meta_tags(
      article: {
        author:       "",
        publisher:    "",
      },
    )
    subject.display_meta_tags(site: "someSite").tap do |meta|
      expect(meta).not_to have_tag("meta", with: { content: "", property: "article:author" })
      expect(meta).not_to have_tag("meta", with: { content: "", property: "article:publisher" })
    end
  end
end
