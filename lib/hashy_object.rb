require "hashy_object/version"

class HashyObject
  class TooMuchRecursionException < Exception; end

  MAX_RECURSION_LEVELS = 100

  attr_accessor :obj
  attr_accessor :recursion_level

  def initialize(obj, recursion_level = 0)
    raise TooMuchRecursionException if recursion_level > MAX_RECURSION_LEVELS
    self.obj = obj
    self.recursion_level = recursion_level
  end

  def inspect
    return obj if obj.is_a?(String)
    return obj.inspect if inspectable?
    inspectify
  end

  def inspectable?
    return true if obj.is_a?(String)
    inspected = obj.inspect
    return false if inspected.match /#</
    true
  end

  def inspectify
    return handle_hashy_array(obj).inspect if obj.class == Array
    return handle_hashy_hash(obj).inspect if obj.class == Hash
    return handle_hashy_to_hash(obj).inspect if obj.respond_to?(:to_hash)
    return handle_hashy_instance_variables(obj).inspect
  end

  private

  def handle_hashy_array(obj)
    [].tap do |out|
      obj.each_with_index do |element, index|
        hashy_element = HashyObject.new(element, recursion_level + 1)
        if hashy_element.inspectable?
          hashy_element = nil
          out[index] = element
        else
          out[index] = hashy_element
        end
      end
    end
  end

  def handle_hashy_hash(obj)
    {}.tap do |out|
      obj.each_pair do |key, value|
        hashy_value = HashyObject.new(value, recursion_level + 1)
        if hashy_value.inspectable?
          hashy_value = nil
          out[key] = value
        else
          out[key] = hashy_value
        end
      end
    end
  end

  def handle_hashy_to_hash(obj)
    obj_hash = obj.to_hash
    if obj_hash.inspect.match(/#</)
      obj_hash.each_pair do |key, value|
        next unless value.inspect.match /#</
        hashy_value = HashyObject.new(value, recursion_level + 1)
        obj_hash[key] = hashy_value.inspect
      end
    end
    obj_hash
  end

  def handle_hashy_instance_variables(obj)
    out = {}
    obj.instance_variables.each do |var|
      hashy_var = HashyObject.new(obj.instance_variable_get(var), recursion_level + 1)
      if hashy_var.inspectable?
        hashy_var = nil
        out[var] = obj.instance_variable_get(var)
      else
        out[var] = hashy_var
      end
    end
    out
  end
end
