require 'rails_helper'

RSpec.describe TmdbSyncService do
  let(:service) { described_class.new }

  before do
    allow(ENV).to receive(:fetch).with("TMDB_API_KEY").and_return("test_api_key")
  end

  describe "#search" do
    it "returns formatted search results" do
      mock_response = double(
        success?: true,
        parsed_response: {
          "results" => [
            {
              "id" => 123,
              "title" => "Inception",
              "overview" => "A thief steals secrets from dreams",
              "poster_path" => "/poster.jpg",
              "release_date" => "2010-07-16",
              "vote_average" => 8.4
            }
          ],
          "total_pages" => 1,
          "total_results" => 1
        }
      )

      allow(HTTParty).to receive(:get).and_return(mock_response)

      result = service.search("Inception")
      expect(result[:results].size).to eq(1)
      expect(result[:results].first[:title]).to eq("Inception")
      expect(result[:results].first[:tmdb_id]).to eq(123)
      expect(result[:total_pages]).to eq(1)
    end

    it "returns empty results on failure" do
      mock_response = double(success?: false)
      allow(HTTParty).to receive(:get).and_return(mock_response)

      result = service.search("nonexistent")
      expect(result[:results]).to be_empty
      expect(result[:total_pages]).to eq(0)
    end
  end

  describe "#sync_movie_details" do
    it "creates or updates a movie from TMDb data" do
      mock_response = double(
        success?: true,
        parsed_response: {
          "id" => 550,
          "title" => "Fight Club",
          "overview" => "An insomniac office worker",
          "poster_path" => "/poster.jpg",
          "backdrop_path" => "/backdrop.jpg",
          "release_date" => "1999-10-15",
          "runtime" => 139,
          "vote_average" => 8.4,
          "popularity" => 60.0,
          "original_language" => "en",
          "genres" => [{ "id" => 18, "name" => "Drama" }],
          "credits" => {
            "cast" => [
              { "id" => 819, "name" => "Edward Norton", "profile_path" => "/p.jpg", "character" => "Narrator" }
            ]
          }
        }
      )

      allow(HTTParty).to receive(:get).and_return(mock_response)

      expect { service.sync_movie_details(550) }.to change(Movie, :count).by(1)
      movie = Movie.find_by(tmdb_id: 550)
      expect(movie.title).to eq("Fight Club")
      expect(movie.runtime).to eq(139)
    end
  end

  describe "#sync_genres" do
    it "creates genres from TMDb" do
      mock_response = double(
        success?: true,
        parsed_response: {
          "genres" => [
            { "id" => 28, "name" => "Action" },
            { "id" => 18, "name" => "Drama" }
          ]
        }
      )

      allow(HTTParty).to receive(:get).and_return(mock_response)

      expect { service.sync_genres }.to change(Genre, :count).by(2)
    end
  end

  describe "#sync_now_playing" do
    it "creates movies from TMDb now_playing endpoint" do
      mock_response = double(
        success?: true,
        parsed_response: {
          "results" => [
            {
              "id" => 999,
              "title" => "Test Movie",
              "overview" => "A test",
              "poster_path" => "/p.jpg",
              "backdrop_path" => "/b.jpg",
              "release_date" => "2025-01-01",
              "vote_average" => 7.5,
              "popularity" => 50.0,
              "original_language" => "en",
              "genre_ids" => []
            }
          ]
        }
      )

      allow(HTTParty).to receive(:get).and_return(mock_response)

      expect { service.sync_now_playing }.to change(Movie, :count).by_at_least(1)
      movie = Movie.find_by(tmdb_id: 999)
      expect(movie.status).to eq("now_playing")
    end
  end
end
