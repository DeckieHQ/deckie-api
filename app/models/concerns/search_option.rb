class SearchOption
  include ActiveModel::Validations

  validate :must_be_supported

  def initialize(attributes, accept:)
    @attributes = attributes
    @accept     = accept
  end

  protected

  attr_reader :attributes, :accept

  def must_be_supported
    errors.add(:base, :unsupported, accept: accept) unless unsupported.empty?
  end

  def unsupported
    throw 'Must be implemented!'
  end
end