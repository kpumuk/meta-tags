require 'spec_helper'

describe MetaTags::Configuration do
  it 'should be returned by MetaTags.config' do
    expect(MetaTags.config).to be_instance_of(MetaTags::Configuration)
  end

  it 'should be yielded by MetaTags.configure' do
    MetaTags.configure do |c|
      expect(c).to be_instance_of(MetaTags::Configuration)
      expect(c).to be(MetaTags.config)
    end
  end
end
