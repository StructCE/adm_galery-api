require 'rails_helper'

RSpec.describe Style, type: :model do
  context 'when verifying title' do
    it 'is ok' do
      style = build(:style)
      expect(style).to be_valid
    end

    it 'when title is nil' do
      style = build(:style, title: '')
      expect(style).not_to be_valid
    end

    it 'when title has less than 3 chars' do
      style = build(:style, title: 'oi')
      expect(style).not_to be_valid
    end

    it 'when the title is not unique' do
      style = build(:style)
      style.save!
      new_style = build(:style)
      expect(new_style).not_to be_valid
    end
  end

  context 'when verifying description' do
    it 'is ok' do
      style = build(:style)
      expect(style).to be_valid
    end

    it 'styles has no description' do
      style = build(:style, description: '')
      expect(style).not_to be_valid
    end

    it 'description is less than 10 chars' do
      style = build(:style, description: 'desc')
      expect(style).not_to be_valid
    end
  end
end
