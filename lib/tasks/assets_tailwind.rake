# tailwindcss-rails chains "assets:precompile" after "tailwindcss:build" in the same
# process. Propshaft memoizes its file listing on first access, and that happens
# before the tailwindcss CLI actually writes app/assets/builds/tailwind.css — so the
# freshly built file is invisible to the precompile step that runs right after, and
# it never makes it into the manifest. Clear the memoized listing once the file exists.
Rake::Task["tailwindcss:build"].enhance do
  Rails.application.assets.load_path.send(:clear_cache)
end
