module Blog
  class PagesController < ApplicationController
    layout 'blog'

    def about; end

    def archive
      @blog_sessions_by_year = BlogSession.all
                                           .sort_by(&:published_on)
                                           .reverse
                                           .group_by { |blog_session| blog_session.published_on.year }
    end
  end
end
