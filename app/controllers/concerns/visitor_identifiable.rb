module VisitorIdentifiable
  extend ActiveSupport::Concern

  included do
    helper_method :current_visitor_id
  end

  private

  # Lazily issues a signed permanent UUID cookie identifying an anonymous visitor.
  def current_visitor_id
    cookies.signed.permanent[:visitor_id] ||= SecureRandom.uuid
  end
end
