class AcceptOfferService
  attr_accessor :offer

  def initialize(offer)
    @offer = offer
  end

  def accept
    # TODO: Charge people and stuff
    offer
  end
end