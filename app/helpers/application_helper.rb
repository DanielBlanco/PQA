#
# Application Helper.
#
# Author::    Daniel (mailto:dblanco@tsys.com)
# Copyright:: Copyright (c) 2009 TSYS.
# License::   ???
#
# Methods added to this helper will be available to all templates in
# the application.
#
module ApplicationHelper

  # application_helper.rb
  def title(page_title)
    content_for(:title) { page_title }
  end

  # Returns a markaby builder.
  def markaby(&block)
    Markaby::Builder.new({}, self, &block).to_s
  end

  # Adds a stylesheet to the html head tag.
  def add_stylesheet(name)
    content_for(:head) do
      stylesheet_link_tag name
    end
  end

  # Adds a new nifty corner to some DOM element.
  def add_nifty_corner(tag, style)
    content_for(:nifty_onload) do
      "Nifty('#{tag}', '#{style}');"
    end
  end

  # Display menu only if there is a project available.
  def display_menu
    if project?
      content_tag(:div, :id => 'menu')  do
        render :partial => 'layouts/menu_nav'
      end
    end
  end

  # Returns a required character.
  def required_field(options={})
    options[:character] ||= '*'
    options[:class] ||= 'required'
    options[:title] ||= 'Required field.'

    markaby do #=> Markaby template.
      span :class => options[:class], :title => options[:title] do
        options[:character]
      end
    end
  end
  alias :req :required_field

  # Displays an status icon image based on the status param.
  def status_png(status)
    status ? 'enabled_icon.png' : 'disabled_icon.png'
  end

  # Displays an status icon image based on the status param.
  def status_icon(status)
    image_tag(status_png(status), :class => 'status_icon', :border => 0, :title => status.to_s)
  end

  # Display the flash messages.
  def flash_messages
    return unless messages = flash.keys.select{|k| flash_keys.include?(k)}
    formatted_messages = messages.map do |type|
      content_tag :div, :id => type, :class => type.to_s do
        msg = flash[type]
        flash.delete(type)
        image_tag("#{type}.png") + "&#160;&#160;" + msg
      end
    end
    '<div id="flashes">' + formatted_messages.join + '</div>'
  end

  # Returns a navigation tab.
  def nav(name="", path=root_path, active='')
    active_class = active == controller.controller_name ? 'activelink' : ''
    markaby do #=> Markaby template.
      li :class => active_class do
        link_to(name, path)
      end
    end
  end

  # Returns the javascript code to bookmark a page.
  def bookmark(title = "My Default Sitewide Bookmark Title", url="#{request.request_uri}")
    url = 'http://' + request.host_with_port + url

    "javascript:bookmarksite('#{title}=>#{request.request_uri}', '#{url}');"
  end

  # Display a value surrounded by <td></td> tags.
  # If the value is greater than max_size it will be cut to max_size...
  # max_size default value is 50 characters.
  # TODO: Remove this method or refactor it.
  def td(value, max_size=50, options={})
    return '<td>&#160;</td>' if value.nil?
    td_title = options[:title] ? "title='#{options[:title]}'" : ''
    "<td #{td_title}>#{h(value.to_s.strip).etc(max_size)}</td>"
  end

  # HTML Word wrap.
  #
  # ===Usage
  # * wordwrap('very long text...')
  # * wordwrap('very long text...', 20)
  # * wordwrap('very long text...', 20, '<br />')
  #
  def wordwrap(text, width=120, string='<wbr />')
    wrapped = ''

    # Get array of words and loop through them.
    (text).scan(/\w+/).each do |word|

      new_word = ''
      if word.length > width
        ((word.length / width)+1).times do |i|
          range = (width*i)..((width*(i+1))-1)
          new_word += word[range] + string
        end
      end
      new_word = word unless word.length > width

      wrapped += new_word + ' ' + string
    end

    wrapped
  end

  # Returns a link to add a form partial into the bottom of some DOM
  # element.
  # The partial file must be _iform.html.erb
  def add_iform_link(name, id, obj, locals={})
    link_to_function name do |page|
      page.insert_html :bottom, id, :partial => 'iform', :object => obj, :locals => locals
    end
  end

  # Displays the field tag.
  def page_field_tag(hidden=true)
    params[:page] ||= 1

    return hidden_field_tag 'page', params[:page] if hidden

    text_field_tag 'page', params[:page]
  end

  # Dynamically create methods for some links with pretty images :).
  #
  # ===Generates:
  # * link_to_edit url
  # * link_to_delete url, :confirm => 'Are you sure?', :method => :delete
  # * link_to_view url
  # * link_to_export url
  # * link_to_excel url
  # * link_to_rss url
  #
  # ===Important:
  # The name of the link only denotes what kind of image we are going to
  # display, nothing more.
  def self.create_image_links
    %w[edit delete view export rss excel].each do |action|
      define_method "link_to_#{action}" do |*args|
        options = args.first || {}
        url = url_for(options)
        html_options = args.second || {}
        html_options[:title] = action.capitalize unless html_options[:title]
        link_to image_tag("link_actions/#{action}.png", :border=>0), url, html_options
      end
    end
  rescue => exception
    Rails.logger.error exception.backtrace
  end
  create_image_links # Calling create_crud_links method.

  # Renders an iform partial.
  def render_iform
    @multi_objs.each do |obj|
      render :partial => 'iform', :object => obj
    end
  end

  # Checks if the URL is valid or not, if it is valid the method returns
  # a link, if isn't valid only text.
  def view_url(url='', max_size=30)
    rexp = /(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*/ix

    if rexp.match(url)
      link_to h(url.etc max_size), url, :title => "Go to #{url}", :popup => true
    else
      content_tag :span, :title => "#{url}" do
        url.etc max_size
      end
    end
  end
end
