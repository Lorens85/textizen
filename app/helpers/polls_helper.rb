module PollsHelper
  def format_poll_type(type)
    case type
    when 'OPEN'
      return 'Open'
    when 'MULTI'
      return 'Multiple Choice'
    end
    return ''
  end

  def sparkline(data, width=100, height=40, style='', _class='')
    return image_tag(Gchart.sparkline(:data=>data, :width=>width, :height=>height, :bg=>'00000000'), :style=>style, :class=>_class)
  end
end
