# frozen_string_literal: true

class AddMovieIdToViewingParties < ActiveRecord::Migration[5.2]
  def change
    add_column :viewing_parties, :movie_id, :integer
  end
end
