# Reads committed devlog markdown files (docs/devlog) as chronologically ordered entries.
# English day_NN.md is the canonical set; day_NN_pt.md is the optional Portuguese variant.
class DevlogEntry
  DEVLOG_DIRECTORY = Rails.root.join('docs', 'devlog')
  PORTUGUESE_LOCALE = 'pt-BR'

  # A collapsible chunk of an entry; heading nil for the leading preamble (date/phase/planned).
  Section = Data.define(:heading, :body)

  attr_reader :day_number, :title, :body

  def initialize(day_number:, title:, body:)
    @day_number = day_number
    @title = title
    @body = body
  end

  # Body split into H2 sections; text before the first H2 is the preamble (heading nil).
  def sections
    preamble, *rest = body.split(/^## (.+)$/)
    parsed = rest.each_slice(2).map { |heading, section_body| Section.new(heading: heading.strip, body: section_body.to_s.strip) }
    parsed.unshift(Section.new(heading: nil, body: preamble.strip))
  end

  # Every entry, newest sprint day first, in the locale-appropriate variant.
  def self.all(locale: I18n.locale)
    day_numbers.reverse.map { |day_number| load(day_number, locale) }
  end

  # Sprint-day numbers derived from the canonical English files.
  def self.day_numbers
    Dir.children(DEVLOG_DIRECTORY)
       .filter_map { |filename| filename[/\Aday_(\d+)\.md\z/, 1]&.to_i }
       .sort
  end

  # Splits the leading H1 (the day title) off the body so it can head a collapsible entry.
  def self.load(day_number, locale)
    title_line, body = File.read(variant_path(day_number, locale)).split("\n", 2)
    new(day_number: day_number, title: title_line.delete_prefix('#').strip, body: body.to_s.strip)
  end

  # Portuguese variant when the locale asks for it and the file exists; English otherwise.
  def self.variant_path(day_number, locale)
    padded = format('%02d', day_number)
    portuguese = DEVLOG_DIRECTORY.join("day_#{padded}_pt.md")
    english = DEVLOG_DIRECTORY.join("day_#{padded}.md")
    locale.to_s == PORTUGUESE_LOCALE && portuguese.exist? ? portuguese : english
  end
end
