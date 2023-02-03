require 'rails_helper'

RSpec.describe 'new view party page' do
  before(:each) do
    User.delete_all

    @user = create(:user)
    @user2 = create(:user)
    @user3 = create(:user)
    @user4 = create(:user)

    json_response = File.read('spec/fixtures/movie.json')
    stub_request(:get, "https://api.themoviedb.org/3/movie/238?api_key=#{ENV['MOVIE_DB_KEY']}")
      .to_return(status: 200, body: json_response, headers: {})

    @movie_detail = MovieDetail.new(JSON.parse(json_response, symbolize_names: true))

    visit new_user_movie_viewing_party_path(@user.id, @movie_detail.id)
  end

  it 'displays the site title and page title at the top' do
    expect(page).to have_content("Viewing Party")
    expect(page).to have_content("Create a Movie Party for '#{@movie_detail.title}'")
  end

  it 'has a link to return to the discover page' do
    expect(page).to have_button("Discover Page")
    click_button("Discover Page")
    expect(current_path).to eq("/users/#{@user.id}/discover")
  end

  it 'has a form to create a viewing party with the movie info already filled in' do
    within "#party_form" do
      expect(page).to have_content("Viewing Party Details")
      expect(page).to have_content("Movie Title: #{@movie_detail.title}")
      expect(page).to have_content("Duration of Party")
      expect(page).to have_field :duration, with: @movie_detail.runtime
      expect(page).to have_field :party_date
      expect(page).to have_field :party_time
      expect(page).to have_content("Invite Other Users")
      expect(page).to have_unchecked_field("#{@user2.name}")
      expect(page).to have_unchecked_field("#{@user3.name}")
      expect(page).to have_unchecked_field("#{@user4.name}")
      expect(page).to have_button("Create Party")
    end
  end

  it 'creates a new viewing party when the form is filled out' do
    within "#party_form" do
      fill_in :duration, with: 190
      fill_in :party_date, with: Date.today + 2.days
      fill_in :party_time, with: Time.now + 1.hours
   
      check("#{@user3.name}")
      check("#{@user2.name}")
    
      click_button("Create Party")
    end
    expect(current_path).to eq("/users/#{@user.id}")
    expect(page).to have_content(@movie_detail.title)
  end

end