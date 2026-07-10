# Reads committed devlog markdown files (docs/devlog) into DevlogEntry value objects — read-side only.
# English day_NN.md is the canonical set; day_NN_pt.md is the optional Portuguese variant.
class DevlogReader
  DEVLOG_DIRECTORY = Rails.root.join('docs', 'devlog')
  PORTUGUESE_LOCALE = 'pt-BR'

  # Every entry, newest sprint day first, in the locale-appropriate variant.
  def self.all(locale: I18n.locale)
    day_numbers.reverse.map { |day_number| entry(day_number, locale) }
  end

  # Sprint-day numbers derived from the canonical English files.
  def self.day_numbers
    Dir.children(DEVLOG_DIRECTORY)
       .filter_map { |filename| filename[/\Aday_(\d+)\.md\z/, 1]&.to_i }
       .sort
  end

  # Reads one entry, splitting the leading H1 (day title) off the body.
  def self.entry(day_number, locale)
    title_line, body = File.read(variant_path(day_number, locale)).split("\n", 2)
    DevlogEntry.new(day_number: day_number, title: title_line.delete_prefix('#').strip, body: body.to_s.strip)
  end

  # Portuguese variant when the locale asks for it and that file exists; English otherwise.
  def self.variant_path(day_number, locale)
    padded = format('%02d', day_number)
    portuguese = DEVLOG_DIRECTORY.join("day_#{padded}_pt.md")
    locale.to_s == PORTUGUESE_LOCALE && portuguese.exist? ? portuguese : DEVLOG_DIRECTORY.join("day_#{padded}.md")
  end
end
