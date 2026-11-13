# frozen_string_literal: true

require "spec_helper"

RSpec.describe MetaTags::ControllerHelper do
  subject do
    MetaTagsRailsApp::MetaTagsController.new.tap do |c|
      c.set_request! ActionDispatch::TestRequest.create
      c.set_response! ActionDispatch::TestResponse.new
    end
  end

  describe "module" do
    it "is mixed into ActionController::Base" do
      expect(ActionController::Base.included_modules).to include(described_class)
    end

    it 'responds to "set_meta_tags" helper' do
      expect(subject).to respond_to(:set_meta_tags)
    end
  end

  describe ".render" do
    it "sets meta tags from instance variables" do
      subject.index
      expect(subject.response.body).to eq("_rendered_")
      expect(subject.meta_tags.meta_tags).to eq("title" => "title", "keywords" => "key1, key2, key3", "description" => "description")
    end

    it "does not require instance variables" do
      subject.show
      expect(subject.response.body).to eq("_rendered_")
      expect(subject.meta_tags.meta_tags).to eq({})
    end

    it "does not fail when instance variables are not set" do
      subject.hide
      expect(subject.response.body).to eq("_rendered_")
      expect(subject.meta_tags.meta_tags).to eq({})
    end
  end

  ["render", "render_to_string"].each do |method|
    describe "##{method} with a template" do
      let(:metadata) { {"title" => "Page", "description" => "Description", "keywords" => ["First", "Second"]} }
      let(:html) { "<title>Page</title>\n<meta name=\"description\" content=\"Description\">\n<meta name=\"keywords\" content=\"first, second\">" }

      before do
        subject.params = {buffered: method == "render_to_string", variables: "set"}
      end

      it "renders all controller variables and preserves the collection" do
        subject.process(:metadata)

        expect(subject.response.body).to eq(html)
        expect(subject.response.status).to eq(201)
        expect(subject.response.media_type).to eq("text/html")
        expect(subject.meta_tags.meta_tags).to eq(metadata)
        if method == "render_to_string"
          expect(subject.buffered_metadata).to eq(html)
          expect(subject.response_after_buffer).to be_nil
        end
      end

      it "gives controller variables precedence over existing metadata" do
        subject.set_meta_tags(title: "Previous", description: "Old description", keywords: ["Old"])
        subject.process(:metadata)

        expect(subject.response.body).to eq(html)
        expect(subject.meta_tags.meta_tags).to eq(metadata)
      end

      it "makes current metadata available while normalizing render values" do
        subject.set_meta_tags(title: "Previous", description: "Old description", keywords: ["Old"])
        subject.params[:text_value] = true
        subject.process(:metadata)

        expect(subject.response.body).to eq(html)
        expect(subject.meta_tags.meta_tags).to eq(metadata)
      end

      ["unset", "nil"].each do |variables|
        context "with #{variables} controller variables" do
          before do
            subject.params[:variables] = variables
          end

          it "renders no metadata when none was set" do
            subject.process(:metadata)

            expect(subject.response.body).to eq("")
            expect(subject.meta_tags.meta_tags).to eq({})
          end

          it "preserves metadata supplied by the explicit setter" do
            subject.set_meta_tags(metadata)
            subject.process(:metadata)

            expect(subject.response.body).to eq(html)
            expect(subject.meta_tags.meta_tags).to eq(metadata)
          end
        end
      end

      it "allows template title updates and restores display defaults" do
        subject.params[:template] = '<% title "Template" %><%= display_meta_tags site: "Site" %>|<%= display_meta_tags %>'
        subject.process(:metadata)

        template_html = html.sub("Page", "Template")
        expect(subject.response.body).to eq("#{template_html.sub("Template", "Site | Template")}|#{template_html}")
        if method == "render_to_string"
          expect(subject.title_after_buffer).to eq("Template")
        end
        expect(subject.meta_tags.meta_tags).to eq(metadata.merge("title" => ((method == "render") ? "Template" : "Page")))
      end
    end
  end

  it_behaves_like ".set_meta_tags"
end
