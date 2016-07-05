require_relative "static_array"

class DynamicArray
  attr_reader :length

  def initialize
    @store = StaticArray.new(DEFAULT_LENGTH)
    @capacity = DEFAULT_LENGTH
    @length = 0
  end

  # O(1)
  def [](index)
    check_index(index)
    @store[index]
  end

  # O(1)
  def []=(index, value)
    @store[index] = value
  end

  # O(1)
  def pop
    check_index
    val = self[length-1]
    @length -= 1
    val
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    resize! if at_capacity?
    self[length] = val
    @length += 1
  end

  # O(n): has to shift over all the elements.
  def shift
    check_index
    new_store = StaticArray.new(length-1)
    (1...length).each { |i| new_store[i] = self[i] }
    @store = new_store
    @length -= 1
  end


  # O(n): has to shift over all the elements.
  def unshift(val)
    new_store = StaticArray.new(length+1)
    new_store[0] = val
    (0...length).each { |i| new_store[i+1] = self[i] }
    @store = new_store
    @length += 1
  end

  protected
  DEFAULT_LENGTH = 8
  BUFFER_RATIO = 2
  attr_accessor :capacity, :store
  attr_writer :length

  def at_capacity?
    @length == @capacity
  end

  def check_index(index = 0)
    raise "index out of bounds" unless index >= 0 && index < length
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
    new_store = StaticArray.new(length * BUFFER_RATIO)
    (0...length).each { |i| new_store[i] = self[i] }
    @store = new_store
    @capacity = @capacity * BUFFER_RATIO
  end
end
