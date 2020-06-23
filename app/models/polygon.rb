class Polygon
  include Mongoid::Document

  validates :value, presence: true

  field :value, type: Object
  field :created_at, type: Date, default: Time.now
end
