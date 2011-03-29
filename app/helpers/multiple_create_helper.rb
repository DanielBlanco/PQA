#
# MultipleCreate Helper.
#
# Author::    Daniel (mailto:dblanco@tsys.com)
# Copyright:: Copyright (c) 2009 TSYS.
# License::   ???
#
module MultipleCreateHelper

  # Returns the value of a check box field from a multi_objs list.
  def check_box_value(index, field_name)
    return false unless params[:multi_objs]

    return false if params[:multi_objs].empty?

    return params[:multi_objs][index][field_name]
  end

end
