# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Movie's detail page" do
  before :each do
    ViewingPartyUser.delete_all
    ViewingParty.delete_all
    User.delete_all

    @user_1 = create(:user)
    @user_2 = create(:user)

    json_response = File.read('spec/fixtures/movie.json')
    stub_request(:get, "https://api.themoviedb.org/3/movie/238?api_key=#{ENV['MOVIE_DB_KEY']}")
      .to_return(status: 200, body: json_response, headers: {})

    @movie_detail = MovieDetail.new(JSON.parse(json_response, symbolize_names: true))

    json_response_cast = File.read('spec/fixtures/cast.json')
    stub_request(:get, "https://api.themoviedb.org/3/movie/238/credits?api_key=#{ENV['MOVIE_DB_KEY']}")
      .to_return(status: 200, body: json_response_cast, headers: {})

    json_response_reviews = File.read('spec/fixtures/reviews.json')
    stub_request(:get, "https://api.themoviedb.org/3/movie/238/reviews?api_key=#{ENV['MOVIE_DB_KEY']}")
      .to_return(status: 200, body: json_response_reviews, headers: {})

    visit login_path
    fill_in :email, with: @user_1.email
    fill_in :password, with: @user_1.password
    click_button("Log In")

    visit "/movies/#{@movie_detail.id}"
  end

  it 'has a button to create a viewing page' do
    expect(page).to have_button("Create a Viewing Party for #{@movie_detail.title}")

    click_button("Create a Viewing Party for #{@movie_detail.title}")
    expect(current_path).to eq("/movies/#{@movie_detail.id}/viewing_parties/new")
  end

  it 'has a button to return to the discover page' do
    expect(page).to have_button('Discover Page')

    click_button('Discover Page')
    expect(current_path).to eq("/discover")
  end

  it 'displays the movie title' do
    expect(page).to have_content(@movie_detail.title.to_s)
  end

  it 'displays the movie vote average' do
    expect(page).to have_content(@movie_detail.vote_average.to_s)
  end

  it 'displays the movie runtime' do
    expect(page).to have_content(@movie_detail.runtime.to_s)
  end

  it 'displays the movie runtime' do
    expect(page).to have_content('Drama Crime')
  end

  it 'displays the movie runtime' do
    expect(page).to have_content(@movie_detail.summary.to_s)
  end

  it 'displays the first ten cast members' do
    within '#actor-3084' do # first cast member
      expect(page).to have_content('Marlon Brando as Don Vito Corleone')
    end

    within '#actor-3091' do # tenth cast member
      expect(page).to have_content("Al Lettieri as Virgil 'The Turk' Sollozzo")
    end
  end

  describe 'review API consumption' do
    before(:each) do
      json_response = File.read('spec/fixtures/reviews.json')
      stub_request(:get, "https://api.themoviedb.org/3/movie/238/reviews?api_key=#{ENV['MOVIE_DB_KEY']}")
        .to_return(status: 200, body: json_response, headers: {})

      @review = MovieFacade.reviews('238').first
    end

    it 'displays reviews' do
      expect(page).to have_content('futuretv')
      expect(page).to have_content('2 Reviews')
      expect(@review.content).to be_a(String)
    end
  end
end
