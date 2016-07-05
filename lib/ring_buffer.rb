require_relative "static_array"

class RingBuffer
  attr_reader :length

  def initialize
    @store = StaticArray.new(DEFAULT_LENGTH)
    @capacity = DEFAULT_LENGTH
    @length = 0
    @start_idx = 0
  end

  # O(1)
  def [](index)
    check_index(index)
    @store[(index + start_idx) % capacity]
  end

  # O(1)
  def []=(index, value)
    @store[(index + start_idx) % capacity] = value
  end

  # O(1)
  def pop
    check_index
    val = store[length-1]
    @length -= 1
    val
  end

  # O(1) ammortized
  def push(val)
    resize! if at_capacity?
    self[length] = val
    @length += 1
    nil
  end

  # O(1)
  def shift
    check_index
    @start_idx = (1 + start_idx) % capacity
    @length -= 1
  end

  # O(1) ammortized
  def unshift(val)
    resize! if at_capacity?
    @start_idx = (start_idx - 1) % capacity
    @length += 1
    self[0] = val
  end

  protected
  DEFAULT_LENGTH = 8
  BUFFER_RATIO = 2
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def at_capacity?
    @length == @capacity
  end

  def check_index(index = 0)
    raise "index out of bounds" unless index >= 0 && index < length
  end

  def resize!
    new_store = StaticArray.new(length * BUFFER_RATIO)
    (0...length).each { |i| new_store[i] = self[i] }
    @store = new_store
    @capacity = @capacity * BUFFER_RATIO
    @start_idx = 0
  end
end
