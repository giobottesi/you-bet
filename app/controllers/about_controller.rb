class AboutController < ContentController
  # Public repository behind the app; the devlog + sources links use path helpers in the view.
  REPOSITORY_URL = 'https://github.com/giobottesi/you-bet'

  # The Instagram post that sparked the project — linked from "esse aqui" in the origin story.
  ORIGIN_POST_URL = 'https://www.instagram.com/p/DZ-iq0UlXvt/'

  # Developer-story sections in Gio's own voice — prose lives at about.story.*.
  STORY_SECTIONS = %i[origin why_this_one].freeze

  # Betina's open questions to Gio — questions are written (about.faq.*.question); answers are Gio's to fill.
  FAQ_QUESTIONS = %i[
    why_this_hill
    hardest_thing
    changed_your_mind
    pairing_with_betina
    what_success_looks_like
    what_you_want_asked
  ].freeze

  def index
    @repository_url = REPOSITORY_URL
    @story_sections = STORY_SECTIONS
    @faq_questions = FAQ_QUESTIONS
  end
end
