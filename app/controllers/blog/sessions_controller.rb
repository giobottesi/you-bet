module Blog
  class SessionsController < ApplicationController
    layout 'blog'

    def index
      @blog_sessions = BlogSession.all
    end

    def show
      @blog_session = BlogSession.find(params[:id])
      raise ActiveRecord::RecordNotFound unless @blog_session
    end
  end
end
