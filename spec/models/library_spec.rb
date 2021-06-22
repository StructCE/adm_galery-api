require 'rails_helper'

RSpec.describe Library, type: :model do
  before do
    create(:artist, id: 1)
    create(:style, id: 1)
    create(:user, id: 1)
    create(:painting, artist_id: 1, style_id: 1, id: 1)
    create(:painting, artist_id: 1, style_id: 1, id: 2)
  end

  context 'when library does not belong to any user' do
    it { expect(build(:library)).to be_invalid }
  end

  context 'when user library is empty' do
    it { expect(build(:library, user_id: 1)).to be_valid }
  end

  context 'when a painting is added to the library' do
    it { expect(build(:library, user_id: 1, painting_ids: 1)).to be_valid }
  end

  context 'when more than one painting is added to library' do
    it { expect(build(:library, user_id: 1, painting_ids: [1, 2])).to be_valid }
  end
end
