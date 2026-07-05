# db:prepare can't tell solid_cache/queue/cable need their schema loaded when
# they share the primary database: it checks "does this database exist" per
# role, and that's already true once primary creates the shared database.
# So load each one explicitly, but only if its table is actually missing.
namespace :db do
  task ensure_solid_schemas: :environment do
    {
      cache: "solid_cache_entries",
      queue: "solid_queue_jobs",
      cable: "solid_cable_messages"
    }.each do |role, table|
      next if ActiveRecord::Base.connection.table_exists?(table)

      ENV["DISABLE_DATABASE_ENVIRONMENT_CHECK"] = "1"
      Rake::Task["db:schema:load:#{role}"].invoke
    end
  end
end

Rake::Task["db:prepare"].enhance do
  Rake::Task["db:ensure_solid_schemas"].invoke
end
