class ListingsController < ApplicationController
  def _msearch
    q = JSON.parse(request.raw_post.split("\n")[1])
    listings = Listing.search(body: q)

    render(json: { responses: { hits: listings.results.as_json } })
  end
end
