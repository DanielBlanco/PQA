%w{
  validators
  string_utils
  enum_utils
  write_excel_file_helper
  pagination_utils
  search_engine
  }.each do |file|

  require file  #=> Loading requirement.

end
