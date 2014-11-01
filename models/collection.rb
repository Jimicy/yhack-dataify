class Collection < ActiveRecord::Base
  validates :collection_id, :name, presence: true
  validates :name, uniqueness: true
end