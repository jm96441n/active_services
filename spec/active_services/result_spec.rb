require 'spec_helper'

RSpec.describe ActiveServices::Result do
  let(:model) { double('Model') }
  subject { ActiveServices::Result.new(model) }

  before do
    allow(model).to receive_message_chain(:errors, :full_messages).and_return([])
  end

  it 'initializes with a model' do
    result = ActiveServices::Result.new(model)
    expect(result.model).to be(model)
  end

  it 'responds to success' do
    expect(subject).to respond_to(:success?)
  end

  it 'responds to errors' do
    expect(subject).to respond_to(:errors)
  end

  describe '.success' do
    context 'no errors' do
      it 'returns true when there are no errors' do
        expect(subject.success?).to be true
      end
    end

    context 'errors' do
      it 'returns false when there are errors' do
        allow(model).to receive_message_chain(:errors, :full_messages).and_return(['I can\'t allow you to do that'])
        expect(subject.success?).to be false
      end
    end
  end
end
