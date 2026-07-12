module AboutHelper
  # The phrase in each locale's origin story that links to the Instagram post that sparked the project.
  ORIGIN_ANCHORS = { 'pt-BR' => 'esse aqui', 'en' => 'this one' }.freeze

  # A story section's localized body; in the origin story, the anchor phrase links to the post.
  def story_body(section)
    body = t("about.story.#{section}.body")
    anchor = ORIGIN_ANCHORS[I18n.locale.to_s]
    return body unless section.to_sym == :origin && anchor && body.include?(anchor)

    link = link_to(anchor, AboutController::ORIGIN_POST_URL,
                   class: 'font-bold text-cyan-ink underline', target: '_blank', rel: 'noopener')
    body.sub(anchor, link).html_safe
  end
end
