module ItemsHelper
  
  def display_icon(type)
    if type == Item::BOOK
      "book"
    elsif type == Item::ARTICLE
      "file-text-alt"
    elsif type == Item::COURSE_KIT
      "paperclip"
    else
      "flag"
    end
  end
  
  def format_field(field)
    if field.blank?
      content_tag(:span, "Not filled in...", class: "weak")
    else
      field
    end
  end
end
