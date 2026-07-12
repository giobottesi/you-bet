module SourcesHelper
  # Bright accents cycled across the notepad bars and note dashes/tape, so no two neighbours match.
  NOTEPAD_ACCENTS = %w[purple coral cyan green yellow].freeze

  # A methodological note's primary-source citations as a separated list of external links.
  def note_citation_links(note)
    safe_join(
      note[:citations].map do |citation|
        link_to citation[:label], citation[:url], class: 'font-bold underline', target: '_blank', rel: 'noopener'
      end,
      ' · '
    )
  end

  # CSS custom property setting a card/note accent from its position in the list.
  def notepad_accent_style(index, property)
    "#{property}: var(--color-#{NOTEPAD_ACCENTS[index % NOTEPAD_ACCENTS.size]})"
  end
end
