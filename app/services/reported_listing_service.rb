class ReportedListingService
  attr_accessor :listing_id

  def initialize(listing_id)
    @listing_id = listing_id
  end

  def report(reporter, text)
    new_report = ListingReport.create(
      listing_id: listing_id,
      text: text,
      user_id: reporter.id,
    )

    if listing.listing_reports.unreviewed.count >= ListingReport::MAX_REPORTS
      listing.disable!
    end

    new_report
  end

  private

  def listing
    @listing ||= Listing.find(listing_id)
  end
end
