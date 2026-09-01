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

  def readme_examples
    blocks = readme.scan(/(?:(?:<!-- executable-example: (?<name>[\w-]+) -->)\n\n)?```ruby\n(?<body>.*?)\n```/m)
    candidates = blocks.select { |_name, body| body.match?(/^set_meta_tags/) && body.match?(/^# </) }
    unmarked = candidates.select { |name, _body| name.nil? }
    raise "Unmarked README examples: #{unmarked.map { |_name, body| body.lines.first.chomp }.join(", ")}" if unmarked.any?

    examples = candidates.flat_map { |name, body| extract_examples(name, body) }
    raise "No executable README examples found" if examples.empty?

    examples
  end

  def extract_examples(name, body)
    examples = []
    source = []
    expected = []

    body.each_line(chomp: true) do |line|
      if line.start_with?("# ")
        expected << line.delete_prefix("# ")
      elsif expected.any?
        examples << [name, source.join("\n"), expected.join("\n")]
        source = line.empty? ? [] : [line]
        expected = []
      else
        source << line
      end
    end

    raise "Expected README output not found: #{name}" if expected.empty?

    examples << [name, source.join("\n"), expected.join("\n")]
  end

  def render_readme_example(source)
    view = MetaTagsRailsApp::MetaTagsView.new(ActionView::LookupContext.new([]), {}, nil)
    view.instance_eval(source, readme_path)
    view.display_meta_tags
  end
end
