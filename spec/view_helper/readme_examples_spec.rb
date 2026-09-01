# frozen_string_literal: true

require "spec_helper"

RSpec.describe MetaTags::ViewHelper, "README rendering examples" do
  let(:readme_path) { File.expand_path("../../README.md", __dir__) }
  let(:readme) { File.read(readme_path) }

  it "executes marked examples from the README" do
    aggregate_failures do
      readme_examples.each do |name, source, expected|
        expect(render_readme_example(source)).to eq(expected), "#{name}:\n#{source}"
      end
    end
  end

  context "when a marked example has no expected output" do
    let(:readme) do
      <<~MARKDOWN
        <!-- executable-example: missing-output -->

        ```ruby
        set_meta_tags title: "Member Login"
        ```
      MARKDOWN
    end

    it "rejects the example" do
      expect { readme_examples }.to raise_error("Expected README output not found: missing-output")
    end
  end

  def readme_examples
    blocks = readme.scan(/(?:<!-- executable-example: (?<name>[\w-]+) -->\n\n)?```ruby\n(?<body>.*?)\n```/m)
    candidates = blocks.select { |_name, body| body.match?(/^set_meta_tags/) && body.match?(/^# </) }
    unmarked = candidates.select { |name, _body| name.nil? }
    raise "Unmarked README examples: #{unmarked.map { |_name, body| body.lines.first.chomp }.join(", ")}" if unmarked.any?

    examples = blocks.flat_map do |name, body|
      next [] unless name

      extract_examples(name, body)
    end
    raise "No executable README examples found" if examples.empty?

    examples
  end

  def extract_examples(name, body)
    examples = []
    source_lines = []
    expected_lines = []

    body.each_line(chomp: true) do |line|
      if line.start_with?("# ")
        expected_lines << line.delete_prefix("# ")
      elsif expected_lines.any?
        examples << [name, source_lines.join("\n"), expected_lines.join("\n")]
        source_lines = line.empty? ? [] : [line]
        expected_lines = []
      else
        source_lines << line
      end
    end

    raise "Expected README output not found: #{name}" if expected_lines.empty?

    examples << [name, source_lines.join("\n"), expected_lines.join("\n")]
  end

  def render_readme_example(source)
    view = MetaTagsRailsApp::MetaTagsView.new(ActionView::LookupContext.new([]), {}, nil)
    view.instance_eval(source, readme_path)
    view.display_meta_tags
  end
end
