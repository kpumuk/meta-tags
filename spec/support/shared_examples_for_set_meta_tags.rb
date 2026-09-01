# frozen_string_literal: true

shared_examples_for ".set_meta_tags" do
  context "with a Hash parameter" do
    it "updates meta tags" do
      subject.set_meta_tags(title: "hello")
      expect(subject.meta_tags[:title]).to eq("hello")

      subject.set_meta_tags(title: "world")
      expect(subject.meta_tags[:title]).to eq("world")
    end
  end

  context "with an Object responding to #to_meta_tags parameter" do
    it "updates meta tags" do
      object1 = double(to_meta_tags: {title: "hello"})
      object2 = double(to_meta_tags: {title: "world"})

      subject.set_meta_tags(object1)
      expect(subject.meta_tags[:title]).to eq("hello")

      subject.set_meta_tags(object2)
      expect(subject.meta_tags[:title]).to eq("world")
    end
  end

  it "uses deep merge when updating meta tags" do
    subject.set_meta_tags(og: {title: "hello"})
    expect(subject.meta_tags[:og]).to eq("title" => "hello")

    subject.set_meta_tags(og: {description: "world"})
    expect(subject.meta_tags[:og]).to eq("title" => "hello", "description" => "world")

    subject.set_meta_tags(og: {admin: {id: 1}})
    expect(subject.meta_tags[:og]).to eq("title" => "hello", "description" => "world", "admin" => {"id" => 1})
  end

  it "normalizes :open_graph to :og" do
    subject.set_meta_tags(open_graph: {title: "hello"})
    expect(subject.meta_tags[:og]).to eq("title" => "hello")
  end

  context "when both Open Graph aliases are provided" do
    [
      [
        "symbol keys with :og first",
        {
          og: {title: "canonical", image: {width: 120, height: 80}},
          open_graph: {description: "alias", image: {width: 640, type: "image/png"}}
        }
      ],
      [
        "string keys with open_graph first",
        {
          "open_graph" => {"description" => "alias", "image" => {"width" => 640, "type" => "image/png"}},
          "og" => {"title" => "canonical", "image" => {"width" => 120, "height" => 80}}
        }
      ]
    ].each do |description, meta_tags|
      it "deep-merges #{description} and gives :og precedence" do
        subject.set_meta_tags(meta_tags)

        expect(subject.meta_tags[:og]).to eq(
          "title" => "canonical",
          "description" => "alias",
          "image" => {"width" => 120, "height" => 80, "type" => "image/png"}
        )
      end
    end

    it "does not mutate a HashWithIndifferentAccess value" do
      open_graph = {description: "alias"}.with_indifferent_access.freeze

      expect do
        subject.set_meta_tags(og: {title: "canonical"}, open_graph: open_graph)
      end.not_to raise_error
      expect(open_graph).to eq("description" => "alias")
    end
  end

  it "continues to give the later update precedence when switching from open_graph to og" do
    subject.set_meta_tags(open_graph: {title: "first", image: {width: 120}})
    subject.set_meta_tags(og: {title: "second", image: {height: 80}})

    expect(subject.meta_tags[:og]).to eq(
      "title" => "second",
      "image" => {"width" => 120, "height" => 80}
    )
  end

  it "continues to give the later update precedence when switching from og to open_graph" do
    subject.set_meta_tags(og: {title: "first", image: {width: 120}})
    subject.set_meta_tags(open_graph: {title: "second", image: {height: 80}})

    expect(subject.meta_tags[:og]).to eq(
      "title" => "second",
      "image" => {"width" => 120, "height" => 80}
    )
  end
end
