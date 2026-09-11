# Obsidian-style callouts: `> [!note] Optional title` becomes a styled blockquote.
# Also matches GitHub alerts (`> [!WARNING]`) since the type is case-insensitive.
module Callouts
  # alias => [visual variant, default title]
  TYPES = {
    "note"      => ["note", "Nota"],
    "info"      => ["note", "Info"],
    "abstract"  => ["note", "Resumen"],
    "summary"   => ["note", "Resumen"],
    "tldr"      => ["note", "TL;DR"],
    "todo"      => ["note", "Pendiente"],
    "question"  => ["note", "Pregunta"],
    "faq"       => ["note", "Pregunta"],
    "example"   => ["note", "Ejemplo"],
    "quote"     => ["note", "Cita"],
    "tip"       => ["tip", "Tip"],
    "hint"      => ["tip", "Tip"],
    "important" => ["tip", "Importante"],
    "success"   => ["tip", "Listo"],
    "done"      => ["tip", "Listo"],
    "warning"   => ["warning", "Advertencia"],
    "caution"   => ["warning", "Precaución"],
    "attention" => ["warning", "Atención"],
    "danger"    => ["danger", "Peligro"],
    "error"     => ["danger", "Error"],
    "failure"   => ["danger", "Falla"],
    "bug"       => ["danger", "Bug"],
  }.freeze

  # Kramdown output: <blockquote>\n  <p>[!type]+/- Title\nbody...</p>
  # (with hard_wrap the newline is preceded by <br />)
  PATTERN = %r{<blockquote>(\s*)<p>\[!([A-Za-z-]+)\][+-]?[ \t]*([^\n<]*(?:<(?!/p>|br\b)[^\n<]*)*)((?:<br\s*/?>)?\n|</p>)}

  def self.convert(html)
    html.gsub(PATTERN) do
      space, type, title, terminator = $1, $2.downcase, $3.strip, $4
      variant, default_title = TYPES.fetch(type, ["note", type.capitalize])
      title = default_title if title.empty?

      out = %(<blockquote class="callout callout-#{variant}" data-callout="#{type}">#{space})
      out << %(<p class="callout-title">#{title}</p>)
      # Title shared its <p> with the body: reopen the paragraph for the rest.
      out << "#{space}<p>" unless terminator == "</p>"
      out
    end
  end
end

Jekyll::Hooks.register [:posts, :pages], :post_render do |doc|
  next unless doc.output_ext == ".html"
  next unless doc.output.include?("[!")
  doc.output = Callouts.convert(doc.output)
end
