class QuoteSerializer < ActiveModel::Serializer
  attributes :id, :quote, :author, :author_about, :tags
  has_one :tag
end
