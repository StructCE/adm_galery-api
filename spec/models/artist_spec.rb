require 'rails_helper'

RSpec.describe Artist, type: :model do
  context 'check validations' do
    it 'when everything is ok' do
      artist = described_class.new(name: 'Artista', biography: 'Eu sou um artista', birthdate: '2002-04-29',
                                   deathdate: '2021-01-05', birthplace: 'Algum Lugar')
      expect(artist).to be_valid
    end

    it 'when name is nil' do
      artist = described_class.new(name: nil, biography: 'Eu sou um artista', birthdate: '2002-04-29',
                                   deathdate: '2021-01-05', birthplace: 'Algum Lugar')
      expect(artist).to be_invalid
    end

    it 'when name is not unique' do
      artist = build(:artist)
      artist.save!
      artist_new = build(:artist)
      expect(artist_new).to be_invalid
    end

    it 'when name is less than 3 characters' do
      artist = described_class.new(name: 'Ar', biography: 'Eu sou um artista', birthdate: '2002-04-29',
                                   deathdate: '2021-01-05', birthplace: 'Algum Lugar')
      expect(artist).to be_invalid
    end

    it 'when birthdate is nil' do
      artist = described_class.new(name: 'Artista', biography: 'Eu sou um artista', birthdate: nil,
                                   deathdate: '2021-01-05', birthplace: 'Algum Lugar')
      expect(artist).to be_invalid
    end

    it 'when birthplace is nil' do
      artist = described_class.new(name: 'Artista', biography: 'Eu sou um artista', birthdate: '2002-04-29',
                                   deathdate: '2021-01-05', birthplace: nil)
      expect(artist).to be_invalid
    end

    it 'when birthplace is less than 3 characters' do
      artist = described_class.new(name: 'Artista', biography: 'Eu sou um artista', birthdate: '2002-04-29',
                                   deathdate: '2021-01-05', birthplace: 'Al')
      expect(artist).to be_invalid
    end

    it 'when birthdate is not a date' do
      artist = described_class.new(name: 'Artista', biography: 'Eu sou um artista', birthdate: 'not a date',
                                   deathdate: '2021-01-05', birthplace: 'Algum Lugar')
      expect(artist).to be_invalid
    end

    it 'when deathdate is not a date' do
      artist = described_class.new(name: 'Artista', biography: 'Eu sou um artista', birthdate: '2002-04-29',
                                   deathdate: 'not a date', birthplace: 'Algum Lugar')
      expect(artist).to be_invalid
    end

    it 'when deathdate is nil' do
      artist = described_class.new(name: 'Artista', biography: 'Eu sou um artista', birthdate: '2002-04-29',
                                   deathdate: nil, birthplace: 'Algum Lugar')
      expect(artist).to be_valid
    end

    it 'when biography is nil' do
      artist = described_class.new(name: 'Artista', biography: nil, birthdate: '2002-04-29',
                                   deathdate: nil, birthplace: 'Algum Lugar')
      expect(artist).to be_invalid
    end

    it 'when biography is less than 10 characters' do
      artist = described_class.new(name: 'Artista', biography: 'Eu', birthdate: '2002-04-29',
                                   deathdate: nil, birthplace: 'Algum Lugar')
      expect(artist).to be_invalid
    end
  end
end
