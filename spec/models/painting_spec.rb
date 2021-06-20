require 'rails_helper'

RSpec.describe Painting, type: :model do
  context 'check validations' do
    let(:artista) { create(:artist) }
    let(:estilo) { create(:style) }

    it 'when everything is ok' do
      pintura = build(:painting, artist_id: artista.id, style_id: estilo.id)
      expect(pintura).to be_valid
    end

    it 'when name is nil' do
      pintura = build(:painting, name: nil, artist_id: artista.id, style_id: estilo.id)
      expect(pintura).to be_invalid
    end

    it 'when year is nil' do
      pintura = build(:painting, year: nil, artist_id: artista.id, style_id: estilo.id)
      expect(pintura).to be_invalid
    end

    it 'when artist is nil' do
      pintura = build(:painting, style_id: estilo.id)
      expect(pintura).to be_invalid
    end

    it 'when style is nil' do
      pintura = build(:painting, artist_id: artista.id)
      expect(pintura).to be_invalid
    end

    it 'when description is nil' do
      pintura = build(:painting, description: nil, artist_id: artista.id, style_id: estilo.id)
      expect(pintura).to be_invalid
    end

    it 'when currentplace is nil' do
      pintura = build(:painting, currentplace: nil, artist_id: artista.id, style_id: estilo.id)
      expect(pintura).to be_invalid
    end

    it 'when name is less than 3 characters' do
      pintura = build(:painting, name: 'Le', artist_id: artista.id, style_id: estilo.id)
      expect(pintura).to be_invalid
    end

    it 'when year is less than 3 characters' do
      pintura = build(:painting, year: '1', artist_id: artista.id, style_id: estilo.id)
      expect(pintura).to be_invalid
    end

    it 'when currentplace is less than 3 characters' do
      pintura = build(:painting, currentplace: 'Mu', artist_id: artista.id, style_id: estilo.id)
      expect(pintura).to be_invalid
    end

    it 'when description is less than 10 characters' do
      pintura = build(:painting, description: 'minus 10', artist_id: artista.id,
                                 style_id: estilo.id)
      expect(pintura).to be_invalid
    end
  end
end
