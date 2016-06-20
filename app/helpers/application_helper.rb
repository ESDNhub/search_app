module ApplicationHelper
  def render_thumbnail(document, options)
    if document[:object].start_with? 'http://'
      img_path = document[:object]
    else
      img_path = 'not_found.png'
    end
    image_tag(img_path, options.merge(alt: presenter(document).document_heading))
  end
end
