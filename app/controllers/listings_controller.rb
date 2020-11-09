class ListingsController < ApplicationController
  include HTTParty
  base_uri Rails.env.production? ? ENV['ELASTICSEARCH_URL'] : 'http://localhost:9200'

  def _msearch
    pref = JSON.parse(request.raw_post.split("\n")[0])
    query = JSON.parse(request.raw_post.split("\n")[1])

    if pref['preference'] == 'SearchResult'
      listings = Listing.all
      if current_user.present?
        listings = listings.where.not(user_id: current_user.id)
      end

      resp = {
        responses: {
          hits:
            listings.search(
              body: query,
              scope_results: lambda do |r|
                user_signed_in? ? r.where.not(user_id: current_user.id) : r
              end,
            ).results.map(&:search_data).as_json,
        },
      }
    else
      resp =
        self.class.post(
          '/listings_development/_msearch',
          body: request.raw_post,
        ).response.body
    end
    render(json: resp)
  end
end
