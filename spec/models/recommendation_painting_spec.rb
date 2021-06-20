require 'rails_helper'

RSpec.describe RecommendationPainting, type: :model do
  describe 'factory' do
    context 'when using standard factory' do
      it { expect(build(:recommendation_painting)).to be_valid }
    end
  end

  describe 'validations' do
    context 'when join table has no painting' do
      it { expect(build(:recommendation_painting, painting: nil)).to be_invalid }
    end

    context 'when join table has no recommendation' do
      it { expect(build(:recommendation_painting, recommendation: nil)).to be_invalid }
    end
  end
end
