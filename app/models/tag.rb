class Tag
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  belongs_to :quote
end
