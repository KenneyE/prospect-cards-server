class ListingsController < ApplicationController
  include HTTParty
  URI_BASE =
    Rails.env.production? ? ENV['ELASTICSEARCH_URL'] : 'http://localhost:9200'

  def _msearch
    pref = JSON.parse(request.raw_post.split("\n")[0])
    query = JSON.parse(request.raw_post.split("\n")[1])

    if pref['preference'] == 'SearchResult'
      listings = Listing.all

      resp = {
        responses: {
          hits:
            listings.search(
              body: query,
              scope_results: lambda do |r|
                user_signed_in? ? r.where.not(user_id: current_user.id) : r
              end,
            ).results.as_json(only: :id),
        },
      }

    else
      r =
        HTTParty.post(
          "#{URI_BASE}/listings_#{Rails.env}/_msearch",
          body: request.raw_post,
          headers: { 'Content-Type': 'application/json' },
        )
  
      resp = r.response.body
    end
    render(json: resp)
  end
end
