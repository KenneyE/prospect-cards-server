class ListingsController < ApplicationController
  def _msearch
    query = params[:query]

    listings = Listing.search({ query: query.to_unsafe_h }) if query

    render json: listings.results.results
  end
end
