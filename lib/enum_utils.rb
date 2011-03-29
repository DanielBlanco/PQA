module Enumerable

  # Calls block with two arguments, the item and its counter, for each
  # item in enum.
  # The counter is like the index in each_with_index method but this can
  # start at any give number.
  #
  # ==Examples
  # <pre>
  # enum.each_with_counter {|obj, i| block } will work the same as
  # each_with_index.
  # </pre>
  #
  # <pre>
  # enum.each_with_counter(3) {|obj, i| block } will start the counter
  # at 3 and go from there.
  # </pre>
  # 
  def each_with_counter(start_at=0, &block)
    self.each_with_index { |elem, i| block.call(elem, start_at+i) } if block_given?
  end
  
end
