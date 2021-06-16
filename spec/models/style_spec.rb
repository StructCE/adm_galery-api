require 'rails_helper'

RSpec.describe Style, type: :model do
  context 'verify title' do
    it 'should be ok' do
      style = build(:style)
      expect(style).to be_valid
    end

    it 'when title is nil' do
      style = build(:style, title: '')
      expect(style).to_not be_valid
    end

    it 'when title has less than 3 chars' do
      style = build(:style, title: 'oi')
      expect(style).to_not be_valid
    end

    it 'when the title is not unique' do
      style = build(:style)
      style.save!
      new_style = build(:style)
      expect(new_style).to_not be_valid
    end
  end

  context 'verify description' do
    it 'should be ok' do 
      style = build(:style)
      expect(style).to be_valid
    end

    it 'styles has no description' do
      style = build(:style, description: '')
      expect(style).to_not be_valid
    end

    it 'description is less than 10 chars' do
      style = build(:style, description: 'desc')
      expect(style).to_not be_valid
    end
  end
end
