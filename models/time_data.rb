class DataTime < ActiveRecord::Base
  validates :collection_id, presence: true
end