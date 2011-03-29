module DialogsHelper

  #
  # Returns a redbox link tag.
  #
  # ===Examples
  #  * link_infobox_to walkthrough_note_dlg_path, 'id1'
  #  * link_infobox_to 'http://www.google.com', 'id2'
  #
  def link_infobox_to(url, id)
    link_to_remote_redbox image_tag("dialog-information.png", :border=>0),
      { :url => url },
      { :id => id }
  end

  def link_searchbox_to(url, id, label='Advanced search', title='Advanced search')
  	  link_to_remote_redbox label,
  	    	{ :url => url, :method => :get},
      		{ :id => id, :title => title }
  end

  #
  # Closes a redbox modal window.
  #
  # ===Examples
  #  * link_infobox_to_close
  #  * link_infobox_to_close 'Cerrar'
  #
  def link_infobox_to_close(name='Close')
    link_to_close_redbox name
  end

end
