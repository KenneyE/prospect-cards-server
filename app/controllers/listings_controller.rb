class ListingsController < ApplicationController
  def _msearch
    query = JSON.parse(request.body.read.split("\n")[1])

    query['size'] = 100

    listings = Listing.search(query) if query

    render json: { listings: { hits: { hits: listings.results.results }  } }
  end
end
