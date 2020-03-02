# frozen_string_literal: true

class AppSerializer
  attr_reader :object, :options

  def initialize(object, options = {})
    @object = object
    @options = options.reverse_merge({ root: true })
  end

  def to_h
    if object.class.to_s.match(/Mongoid/)
      collection_to_hash
    else
      object_to_hash
    end
  end

  private

  def collection_to_hash
    collection = object.to_a.map{ |obj| serialize(obj) }
    return collection.to_h unless options[:root]

    hash = {}
    hash[get_key.pluralize] = collection
    hash["pagination"] = pagination_hash(object) if options[:paginate]
    hash
  end

  def object_to_hash
    obj = serialize(object)
    return obj.to_h unless options[:root]

    { "#{get_key}" => obj }.to_h
  end

  def pagination_hash(object)
    {
      total_pages: object.total_pages,
      current_page: object.current_page,
      next_page: object.next_page,
      prev_page: object.prev_page
    }
  end

  def get_key
    return options[:root_key] if options[:root_key]
    key = object.is_a?(Mongoid::Criteria) ? object.klass : object.class
    key.to_s.downcase
  end
end
