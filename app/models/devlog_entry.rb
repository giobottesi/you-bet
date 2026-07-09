# Reads committed devlog markdown files (docs/devlog) as chronologically ordered entries.
# English day_NN.md is the canonical set; day_NN_pt.md is the optional Portuguese variant.
class DevlogEntry
  DEVLOG_DIRECTORY = Rails.root.join('docs', 'devlog')
  PORTUGUESE_LOCALE = 'pt-BR'

  attr_reader :day_number, :body

  def initialize(day_number:, body:)
    @day_number = day_number
    @body = body
  end

  # Every entry, ascending by sprint-day number, in the locale-appropriate variant.
  def self.all(locale: I18n.locale)
    day_numbers.map { |day_number| load(day_number, locale) }
  end

  # Sprint-day numbers derived from the canonical English files.
  def self.day_numbers
    Dir.children(DEVLOG_DIRECTORY)
       .filter_map { |filename| filename[/\Aday_(\d+)\.md\z/, 1]&.to_i }
       .sort
  end

  def self.load(day_number, locale)
    new(day_number: day_number, body: File.read(variant_path(day_number, locale)))
  end

  # Portuguese variant when the locale asks for it and the file exists; English otherwise.
  def self.variant_path(day_number, locale)
    padded = format('%02d', day_number)
    portuguese = DEVLOG_DIRECTORY.join("day_#{padded}_pt.md")
    english = DEVLOG_DIRECTORY.join("day_#{padded}.md")
    locale.to_s == PORTUGUESE_LOCALE && portuguese.exist? ? portuguese : english
  end
end
