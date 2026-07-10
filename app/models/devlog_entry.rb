# One devlog entry as an immutable value object. Parsing that belongs to the entry lives here;
# file I/O and locale selection are DevlogReader's job.
DevlogEntry = Data.define(:day_number, :title, :body) do
  # A collapsible chunk of an entry; heading nil for the leading preamble (date/phase/planned).
  Section = Data.define(:heading, :body)

  # Body split into H2 sections; text before the first H2 is the preamble (heading nil).
  def sections
    preamble, *rest = body.split(/^## (.+)$/)
    parsed = rest.each_slice(2).map { |heading, section_body| Section.new(heading: heading.strip, body: section_body.to_s.strip) }
    parsed.unshift(Section.new(heading: nil, body: preamble.strip))
  end
end
