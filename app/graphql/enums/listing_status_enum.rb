# Actions for the client to check the current admins abilities agains
class Enums::ListingStatusEnum < Enums::BaseEnum
  value('available', 'available')
  value('pending_sale', 'pending_sale')
  value('sold', 'sold')
  value('disabled', 'disabled')
end
