#
# /lib/validators.rb
# Custom validators for my models.
#
# I'm extending ActiveRecord to have a feel that my validators are
# within rails.
#
module ActiveRecord
  module Validations
    module ClassMethods
      #----------------------------------------------------------

      @@is_ticket_number_msg = 'Ticket must have a XX-####### or XXX-####### format.'
      @@is_ticket_number     = /\A[a-z]{2,3}\-\d{7}\Z/i

      @@is_url_msg = 'The format of the url is not valid.'
      @@is_url     = /(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*/ix

      @@is_vss_file_msg = 'Invalid VSS file.'
      @@is_vss_file = /^\$\/[a-z0-9\/\-_\.]+$/i

      #----------------------------------------------------------

      # Calls the 'validates_format_of' method with the attributes and
      # configuration provided.
      #
      def do_as_format_of(attr_names, configuration)
        configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)
        validates_format_of attr_names, configuration
      end

      # Validates whether the value of the specified attribute is of the correct
      # form by matching it against the regular expression /\A[a-z]{2,3}\-\d{7}\Z/i
      #
      #   class Deployment < ActiveRecord::Base
      #     validates_as_ticket_number :ticket
      #   end
      #
      # ===Configuration options:
      # * Check validates_format_of configuration options.
      #
      def validates_as_ticket_number(*attr_names)
        configuration = {
          :message   => @@is_ticket_number_msg,
          :with      => @@is_ticket_number }

        do_as_format_of(attr_names, configuration)
      end

      # Validates whether the value of the specified attribute is of the correct
      # form by matching it against a regular expression.
      #
      #   class Deployment < ActiveRecord::Base
      #     validates_as_url :url
      #   end
      #
      # ===Configuration options:
      # * Check validates_format_of configuration options.
      #
      # ===Note:
      # If you want to validate if the URI is valid or not or have extra
      # validation parameters check:
      # * http://github.com/RISCfuture/validates_url/tree/master
      def validates_as_url(*attr_names)
        configuration = {
          :message   => @@is_url_msg,
          :with      => @@is_url }

        do_as_format_of(attr_names, configuration)
      end

      # Validates whether the value of the specified attribute is of the correct
      # form by matching it against a regular expression.
      #
      #   class Deployment < ActiveRecord::Base
      #     validates_as_vss_file :file
      #   end
      #
      # ===Configuration options:
      # * Check validates_format_of configuration options.
      def validates_as_vss_file(*attr_names)
        configuration = {
          :message   => @@is_vss_file_msg,
          :with      => @@is_vss_file }

        do_as_format_of(attr_names, configuration)
      end


      def validate_at_least_one_of(*attrs)
      configuration = { :message => "#{attrs.to_sentence(:two_words_connector => ' or ').gsub('_',' ').capitalize} must be set",
                                    :on => :save }
      configuration.update(attrs.pop) if attrs.last.is_a?(Hash)
      options = configuration
      send(validation_method(options[:on] || :save)) do |record|
          found_non_blank = false
          attrs.each do |attr|
            value = record.send(attr)
            if !value.blank?
                found_non_blank = true
            end
          end # attrs.each

          if ! found_non_blank
            record.errors.add(attrs.first, configuration[:message])
          end
      end  # send
     end

      # Validates whether the value of the specified attribute contains
      # values
      #
      #   class Deployment < ActiveRecord::Base
      #     validates_as_ticket_number :ticket
      #   end
      #
      # ===Configuration options:
      # * Check validates_format_of configuration options.
      #
      def validates_length_of_csv_values(*attrs)
        # Merge given options with defaults.
        options = {
          :tokenizer => lambda {|value| value.split(//)},
          :separator => ','
        }.merge(DEFAULT_VALIDATION_OPTIONS)
        options.update(attrs.extract_options!.symbolize_keys)

        # Ensure that one and only one range option is specified.
        range_options = ALL_RANGE_OPTIONS & options.keys
        case range_options.size
          when 0
            raise ArgumentError, 'Range unspecified.  Specify the :within, :maximum, :minimum, or :is option.'
          when 1
            # Valid number of options; do nothing.
          else
            raise ArgumentError, 'Too many range options specified.  Choose only one.'
        end

        # Get range option and value.
        option = range_options.first
        key = {:is => :wrong_length, :minimum => :too_short, :maximum => :too_long}[option]
        option_value = options[range_options.first]

        case option
          when :within, :in
            raise ArgumentError, ":#{option} must be a Range" unless option_value.is_a?(Range)

            validates_each(attrs, options) do |record, attr, value|
              raise ArgumentError, ":#{attr} must have a String value." unless value.kind_of?(String)

              value = options[:tokenizer].call(value)

              csv = value.split(options[:separator])

              csv.each do |v|
                custom_message = options[:message] || "each value should be between #{option_value.begin} and #{option_value.end} characters."
                if v.nil? or v.size < option_value.begin
                  record.errors.add(attr, :too_short, :default => custom_message || options[:too_short], :count => option_value.begin)
                elsif v.size > option_value.end
                  record.errors.add(attr, :too_long, :default => custom_message || options[:too_long], :count => option_value.end)
                end
              end
            end
          when :is, :minimum, :maximum
            raise ArgumentError, ":#{option} must be a nonnegative Integer" unless option_value.is_a?(Integer) and option_value >= 0

            # Declare different validations per option.
            validity_checks = { :is => "==", :minimum => ">=", :maximum => "<=" }

            validates_each(attrs, options) do |record, attr, value|
              raise ArgumentError, ":#{attr} must have a String value." unless value.kind_of?(String)

              value = options[:tokenizer].call(value)

              csv = value.split(options[:separator])

              csv.each do |v|
                unless !v.nil? and v.size.method(validity_checks[option])[option_value]
                  custom_message = options[:message] || "each value should not exceed #{option_value} characters."
                  record.errors.add(attr, key, :default => custom_message, :count => option_value)
                  break;
                end
              end
            end
        end
      end

    end
  end
end
