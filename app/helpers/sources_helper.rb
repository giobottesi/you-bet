module SourcesHelper
  # A methodological note's primary-source citations as a separated list of external links.
  def note_citation_links(note)
    safe_join(
      note[:citations].map do |citation|
        link_to citation[:label], citation[:url], class: 'font-bold underline', target: '_blank', rel: 'noopener'
      end,
      ' · '
    )
  end
end
