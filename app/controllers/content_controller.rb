# Abstract base for static content pages (Sources now; FE-13/14/15 extend this).
class ContentController < ApplicationController
  layout 'content'

  REPOSITORY_URL = 'https://github.com/giobottesi/you-bet'.freeze
end
