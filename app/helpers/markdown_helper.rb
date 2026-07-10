# Renders trusted committed markdown (devlog entries) to HTML.
module MarkdownHelper
  def render_markdown(text)
    markdown_renderer.render(text.to_s).html_safe
  end

  private

  # Memoized per view; hard_wrap keeps single-newline metadata lines on separate lines.
  def markdown_renderer
    @markdown_renderer ||= Redcarpet::Markdown.new(
      Redcarpet::Render::HTML.new(hard_wrap: true),
      autolink: true,
      tables: true,
      fenced_code_blocks: true,
      strikethrough: true,
      no_intra_emphasis: true
    )
  end
end
