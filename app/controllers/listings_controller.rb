class ListingsController < ApplicationController
  include HTTParty
  URI_BASE =
    Rails.env.production? ? ENV['ELASTICSEARCH_URL'] : 'http://localhost:9200'

  def _msearch
    pref = JSON.parse(request.raw_post.split("\n")[0])
    query = JSON.parse(request.raw_post.split("\n")[1])

    listings = Listing.all

    results =
      listings.search(
        body: query,
        scope_results: lambda do |r|
          user_signed_in? ? r.where.not(user_id: current_user.id) : r
        end,
      )

    resp = if pref['preference'] == 'SearchResult'
             { responses: { hits: results.results.as_json(only: :id) } }
           else
             results.response
           end
    render(json: resp)
  end
end
