module ConfigurationsHelper

  # Dynamically create methods for each configuration.
  begin
    Configuration.configs_cached.each do |c|
      #Rails.logger.info c.config_values
	  define_method "#{c.name.gsub(/\s/, "_").downcase}_select_options" do
	  	c.config_values.split(",")
	  end
    end
  rescue => exception
    Rails.logger.error exception.backtrace
  end
  
end
