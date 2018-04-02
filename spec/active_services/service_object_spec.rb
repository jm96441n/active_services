require 'spec_helper'

RSpec.describe ActiveServices::ServiceObject do
  let(:model) { double('Model') }
  subject { ActiveServices::ServiceObject.new() }

  it 'raises a NotImplementedError for the call method' do
    expect{ subject.call }.to raise_error ActiveServices::NotImplementedError
  end
end
