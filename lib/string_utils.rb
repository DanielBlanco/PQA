# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
# Overwrite or add some utility methods to String class.
class String
 
  # Returns the substring of this string from 0 to max_size #=>self[0, max_size]
  # and appends the value of suffix param.
  # max_size default => 50
  #
  # ==examples:
  #   "hello world".etc(4) #=> hell...
  #   "hello world".etc(25) #=> hello world
  #   "hello world".etc(4, ', etc.') #=> hell, etc.
  #
  def etc(max_size=50, suffix='...')
    self.length > max_size ? self[0, max_size]+suffix : self
  end
  
  # Convert a string into a boolean
  # ==examples:
  #		"true" return true
  #		"yes" return true
  #		all others return false
  def to_b
  	if(self.downcase.eql?("yes") || self.downcase.eql?("true"))
  		return true
  	else 
  		if(self.downcase.eql?("no") || self.downcase.eql?("false"))
  			return false
  		else
  			return nil
  		end
  	end
  end
  
  # Convert a string into a date  
  # An invalid string will return nill  
  def to_date
  	date = nil
  	begin
  		date = Time.parse(self)
  	rescue
  		Logger.error(self + " is not a valid date")
  	end
  	return date
  end
  
end
