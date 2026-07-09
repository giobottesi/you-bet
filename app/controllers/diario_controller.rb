# Daily devlog page (/diario) — renders committed devlog entries chronologically.
class DiarioController < ContentController
  def index
    @entries = DevlogEntry.all
  end
end
