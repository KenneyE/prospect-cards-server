class SuggestionService
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def might_also_like
    names = user.players.map(&:name)

    __elasticsearch__.search(
      query: { bool: { must: { term: { 'players.name': names } } } },
      aggs: recommendations_aggregations,
    )
  end

  private

  def recommendations_aggregations
    {
      recommendations: {
        significant_terms: {
          field: 'players', exclude: names, min_doc_count: 0
        },
      },
    }
  end
end
