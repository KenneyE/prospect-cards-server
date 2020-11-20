class ListingsController < ApplicationController
  include HTTParty
  URI_BASE =
    Rails.env.production? ? ENV['ELASTICSEARCH_URL'] : 'http://localhost:9200'

  def _msearch
    query = JSON.parse(request.raw_post.split("\n")[1])

    listings = Listing.all

    results =
      listings.search(
        body: query,
        scope_results: lambda do |r|
          # user_signed_in? ? r.where.not(user_id: current_user.id) : r
          r
        end,
      )

    render(json: { responses: { hits: results.results.as_json(only: :id) } })
  end
end
