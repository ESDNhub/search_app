module DblaHelper
  include Dbla::ApplicationHelperBehavior

  def show_item_clean_title fld
    puts @document['sourceResource']['title']
    fld = @document['sourceResource']['title'][0]
  end

  def show_item_begin_date fld
    first_date = @document['sourceResource']['date'][0]['begin'][0..3]
    second_date = @document['sourceResource']['date'][0]['end'][0..3]
    if first_date == second_date
      fld = first_date
    else
      fld = first_date + " - " + second_date
    end
  end

  def render_item_thumbnail_tag doc
    link_to image_tag(doc[:object]), doc[:isShownAt], :target => "_blank"
  end
end
