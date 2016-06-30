module ApplicationHelper
  def render_thumbnail(document, options)
    if document[:object].respond_to? :start_with?
      img_path = document[:object].start_with?("http:/") ? document[:object] : 'not_found.png' 
      image_tag(img_path, options.merge(alt: presenter(document).document_heading))
    end
  end
end
