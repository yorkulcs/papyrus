class My::ItemsController < My::BaseController

  def show
    @items = @student.current_items
    @courses = @items.map {|i| i.courses }.flatten.map{ |c| short_name(c.code)}.uniq

    @courses_grouped = @courses.group_by { |c| c.split(" ").first }

    if params[:course].present?
      course_chuncks = params[:course].split("_")
      i = @items.joins(:courses).group('items.id').where("courses.code LIKE '%_#{course_chuncks[0]}_%_%#{course_chuncks[1]}_%'")
      @items_grouped = i.group_by { |i| i.item_type }
    else
      @items_grouped = @items.group_by { |i| i.item_type }
    end
  end

  def short_name(code)
     if code
       chunks = code.split("_")
       return "#{chunks[2]} #{chunks[4]}"
     else
       return code
     end
   end

end
