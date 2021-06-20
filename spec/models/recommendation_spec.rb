require 'rails_helper'

RSpec.describe Recommendation, type: :model do
  context 'when verifying title' do
    it 'is ok' do
      recommendation = build(:recommendation)
      expect(recommendation).to be_valid
    end

    it 'when title is nil' do
      recommendation = build(:recommendation, title: '')
      expect(recommendation).not_to be_valid
    end

    it 'when title has less than 3 chars' do
      recommendation = build(:recommendation, title: 'oi')
      expect(recommendation).not_to be_valid
    end

    it 'when the title is not unique' do
      recommendation = build(:recommendation)
      recommendation.save!
      new_recommendation = build(:recommendation)
      expect(new_recommendation).not_to be_valid
    end
  end

  context 'when verifying description' do
    it 'is ok' do
      recommendation = build(:recommendation)
      expect(recommendation).to be_valid
    end

    it 'styles has no description' do
      recommendation = build(:recommendation, description: '')
      expect(recommendation).not_to be_valid
    end

    it 'description is less than 10 chars' do
      recommendation = build(:recommendation, description: 'desc')
      expect(recommendation).not_to be_valid
    end
  end
end
