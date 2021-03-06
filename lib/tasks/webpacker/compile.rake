$stdout.sync = true

namespace :webpacker do
  desc "Compile javascript packs using webpack for production with digests"
  task compile: ["webpacker:verify_install", :environment] do
    Webpacker.ensure_log_goes_to_stdout do
      if Webpacker::Compiler.compile
        # Successful compilation!
      else
        # Failed compilation
        exit!
      end
    end
  end
end

# Compile packs after we've compiled all other assets during precompilation
if Rake::Task.task_defined?("assets:precompile")
  Rake::Task["assets:precompile"].enhance do
    unless Rake::Task.task_defined?("yarn:install")
      # For Rails < 5.1
      Rake::Task["webpacker:yarn_install"].invoke
    end
    Rake::Task["webpacker:compile"].invoke
  end
end
