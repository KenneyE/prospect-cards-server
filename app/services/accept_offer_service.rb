class AcceptOfferService
  attr_accessor :offer

  def initialize(offer)
    @offer = offer
  end

  def accept
    offer
  end
end