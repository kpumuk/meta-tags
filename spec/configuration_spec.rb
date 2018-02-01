require 'spec_helper'

describe MetaTags::Configuration do
  it 'is returned by MetaTags.config' do
    expect(MetaTags.config).to be_instance_of(described_class)
  end

  it 'is yielded by MetaTags.configure' do
    MetaTags.configure do |c|
      expect(c).to be_instance_of(described_class)
      expect(c).to be(MetaTags.config)
    end
  end
end
