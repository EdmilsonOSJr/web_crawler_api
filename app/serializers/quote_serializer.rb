class QuoteSerializer < ActiveModel::Serializer
  attributes :quote, :author, :author_about, :tags
  #has_one :tag
end
