module DeploymentsHelper

  # Returns a navigation tab for deployment's menu.
  def dnav(name, path, active='')
    active_class = ''
    active.split(',').each do |action|
      if controller.action_name == action
        active_class = 'activelink'
        break
      end
    end
    markaby do #=> Markaby template.
      li :class => active_class do
        link_to(name, path)
      end
    end
  end

  # Returns the list of actions over a file.
  def file_action_list(section)
    logger.info 'Section is: ' + section
    case section
      when 'Delete'
        %w[Delete]
      when '', nil
        %w[Add Update]
      else
        %w[Add Update Delete]
    end
  end
end
