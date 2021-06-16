require 'rails_helper'

RSpec.describe Artist, type: :model do
  context 'check validations' do
    it 'when everything is ok' do
      artist = Artist.new(name: "Artista", biography: "Eu sou um artista", birthdate: "2002-04-29", deathdate: "2021-01-05", birthplace: "Algum Lugar")
      expect(artist).to be_valid
    end

    it 'when name is nil' do
      artist = Artist.new(name: nil, biography: "Eu sou um artista", birthdate: "2002-04-29", deathdate: "2021-01-05", birthplace: "Algum Lugar")
      expect(artist).to be_invalid
    end

    it 'when name is less than 3 characters' do
      artist = Artist.new(name: "Ar", biography: "Eu sou um artista", birthdate: "2002-04-29", deathdate: "2021-01-05", birthplace: "Algum Lugar")
      expect(artist).to be_invalid
    end

    it 'when birthdate is nil' do
      artist = Artist.new(name: "Artista", biography: "Eu sou um artista", birthdate: nil, deathdate: "2021-01-05", birthplace: "Algum Lugar")
      expect(artist).to be_invalid
    end

    it 'when birthplace is nil' do
      artist = Artist.new(name: "Artista", biography: "Eu sou um artista", birthdate: "2002-04-29", deathdate: "2021-01-05", birthplace: nil)
      expect(artist).to be_invalid
    end

    it 'when birthplace is less than 3 characters' do
      artist = Artist.new(name: "Artista", biography: "Eu sou um artista", birthdate: "2002-04-29", deathdate: "2021-01-05", birthplace: "Al")
      expect(artist).to be_invalid
    end

    it 'when birthdate is not a date' do
      artist = Artist.new(name: "Artista", biography: "Eu sou um artista", birthdate: "not a date", deathdate: "2021-01-05", birthplace: "Algum Lugar")
      expect(artist).to be_invalid
    end

    it 'when deathdate is not a date' do
      artist = Artist.new(name: "Artista", biography: "Eu sou um artista", birthdate: "2002-04-29", deathdate: "not a date", birthplace: "Algum Lugar")
      expect(artist).to be_invalid
    end

    it 'when deathdate is nil' do
      artist = Artist.new(name: "Artista", biography: "Eu sou um artista", birthdate: "2002-04-29", deathdate: nil, birthplace: "Algum Lugar")
      expect(artist).to be_valid
    end
  end
end
