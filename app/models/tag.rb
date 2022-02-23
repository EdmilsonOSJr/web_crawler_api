class Tag
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: Strin

  has_many :quotes
end
