class Serialized
  def initialize(serializer)
    @serializer = serializer
  end

  def relationships
    content['data']['relationships']
  end

  def attributes
    content['data']['attributes']
  end

  def content
    @content ||= JSON.parse(
      ActiveModel::Serializer::Adapter.create(@serializer).to_json
    )
  end
end

module Serialize
  extend self

  def params(attributes = {}, type:)
    {
      data: {
        type: type,
        attributes: attributes
      }
    }.to_json
  end

  def query(page: nil, filters: nil, sort: nil)
    query = {}
    if page
      query[:page] = { number: page.number, size: page.size }
    end
    if filters
      query[:filters] = filters
    end
    if sort
      query[:sort] = sort
    end
    query
  end
end
