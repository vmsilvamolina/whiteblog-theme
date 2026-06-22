Jekyll::Hooks.register [:posts, :pages], :post_render do |doc|
  next unless doc.output_ext == ".html"
  doc.output = doc.output.gsub(/<img(?![^>]*\bloading=)/, '<img loading="lazy"')
end
