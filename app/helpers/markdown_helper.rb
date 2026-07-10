# Renders trusted committed markdown (devlog entries) to HTML.
module MarkdownHelper
  # Reusable renderer; hard_wrap keeps single-newline metadata lines on separate lines.
  MARKDOWN_RENDERER = Redcarpet::Markdown.new(
    Redcarpet::Render::HTML.new(hard_wrap: true),
    autolink: true,
    tables: true,
    fenced_code_blocks: true,
    strikethrough: true,
    no_intra_emphasis: true
  )

  def render_markdown(text)
    MARKDOWN_RENDERER.render(text.to_s).html_safe
  end
end
