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

    context 'when the join is not unique' do
      it 'expects new join to not be valid' do
        artist = create(:artist)
        style = create(:style)
        painting = create(:painting, artist: artist, style: style)
        recommendation = create(:recommendation)
        join = create(:recommendation_painting, painting: painting, recommendation: recommendation)
        new_join = build(:recommendation_painting, painting: painting, recommendation: recommendation)
        expect(new_join).not_to be_valid
      end
    end
  end
end
