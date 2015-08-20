require 'spec_helper'

describe MetaTags::TextNormalizer, '.truncate_array' do
  it 'should return array as is when limit is not specified' do
    arr = %w[a]
    expect(subject.truncate_array(arr, nil)).to be(arr)
    expect(subject.truncate_array(arr, 0)).to be(arr)
  end

  it 'should return a new array when limit is specified' do
    arr = %w[a]
    expect(subject.truncate_array(arr, 1)).to_not be(arr)
  end

  context 'when separator is empty string' do
    it 'should return the whole array when total size is less than or equal to limit' do
      arr = %w[a a]
      expect(subject.truncate_array(arr, 5)).to eq(arr)
      expect(subject.truncate_array(arr, 2)).to eq(arr)
    end

    it 'should truncate array to specified limit' do
      arr = %w[a a a a a]
      expect(subject.truncate_array(arr, 3)).to eq(%w[a a a])
    end

    it 'should truncate last word to match the limit' do
      arr = %w[a a aaaa aa]
      expect(subject.truncate_array(arr, 4)).to eq(%w[a a aa])
    end

    it 'should use natural separator when truncating a long word' do
      arr = ['a', 'aa aaaa', 'aa']
      expect(subject.truncate_array(arr, 7)).to eq(%w[a aa])
    end
  end

  context 'when separator is specified' do
    it 'should return the whole array when total size is less than or equal to limit' do
      arr = %w[a a]
      expect(subject.truncate_array(arr, 5, '-')).to eq(arr)
      expect(subject.truncate_array(arr, 3, '-')).to eq(arr)
    end

    it 'should truncate array to specified limit' do
      arr = %w[a a a a a]
      expect(subject.truncate_array(arr, 3, '-')).to eq(%w[a a])
    end

    it 'should truncate last word to match the limit' do
      arr = %w[a a aaaa aa]
      expect(subject.truncate_array(arr, 5, '-')).to eq(%w[a a a])
    end

    it 'should use natural separator when truncating a long word' do
      arr = ['a', 'aa aaaa', 'aa']
      expect(subject.truncate_array(arr, 7, '-')).to eq(%w[a aa])
    end
  end
end
