# Preview-only content for the magicagem blog scaffold (whimsy palette spike).
class BlogSession
  SESSIONS = [
    {
      id: 'the-rose-quartz-that-waited',
      title: 'The rose quartz that waited',
      published_on: Date.new(2014, 3, 12),
      crystal: 'Rose Quartz',
      mood: 'soft & patient',
      excerpt: 'Found it in a box of things my grandmother never unpacked. It took eight months to feel ready to hold it during a full moon.',
      body: "Found it in a box of things my grandmother never unpacked. It took eight months to feel ready to hold it during a full moon.\n\nI keep it on the windowsill now, catching the first light. Some sessions aren't about doing anything with a stone — just sitting with it until it tells you what it's for."
    },
    {
      id: 'a-tarot-pull-for-the-new-moon',
      title: 'A tarot pull for the new moon',
      published_on: Date.new(2014, 6, 30),
      crystal: 'Moonstone',
      mood: 'quiet & curious',
      excerpt: 'Three cards, one candle, and the loudest silence I have felt all year. The Star showed up again.',
      body: "Three cards, one candle, and the loudest silence I have felt all year. The Star showed up again.\n\nI wrote the reading longhand this time instead of typing it. Something about the pen slowing me down made the cards easier to trust."
    },
    {
      id: 'amethyst-and-the-long-drive-home',
      title: 'Amethyst and the long drive home',
      published_on: Date.new(2014, 9, 18),
      crystal: 'Amethyst',
      mood: 'grounded & grateful',
      excerpt: 'Kept it in the cup holder the whole trip. Silly, maybe, but the drive felt lighter.',
      body: "Kept it in the cup holder the whole trip. Silly, maybe, but the drive felt lighter.\n\nThis is the part of the practice nobody warns you about: how ordinary it becomes. A stone in a cup holder. A ritual that fits inside a commute."
    }
  ].freeze

  attr_reader :id, :title, :published_on, :crystal, :mood, :excerpt, :body

  def initialize(attributes)
    attributes.each { |key, value| instance_variable_set(:"@#{key}", value) }
  end

  def self.all
    SESSIONS.map { |attributes| new(attributes) }
  end

  def self.find(id)
    attributes = SESSIONS.find { |session| session[:id] == id }
    attributes && new(attributes)
  end
end
