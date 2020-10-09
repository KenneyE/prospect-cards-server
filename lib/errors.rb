# typed: strong
module Errors
  class UserInputError < StandardError; end
  class InvalidOfferError <StandardError; end

  class ConfirmationError <StandardError; end
end
