require 'spec_helper'

RSpec.describe ActiveServices::ServiceObject do
  let(:model) { double('Model') }
  subject { ActiveServices::ServiceObject.new() }

  describe '.call' do
    it 'raises a NotImplementedError for the call method' do
      expect{ subject.call }.to raise_error ActiveServices::NotImplementedError
    end
  end

  describe '.result' do
    it 'instantiates a new result object with the model in question' do
      expect(subject.result(model)).to be_a_kind_of ActiveServices::Result
    end
  end
end
