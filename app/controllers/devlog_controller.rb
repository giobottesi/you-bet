# Daily devlog page (/devlog) — renders committed devlog entries chronologically.
class DevlogController < ContentController
  def index
    @entries = DevlogEntry.all
  end
end
