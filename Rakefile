require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

# Override the git_push task to handle detached HEAD state in CI
# This is necessary because GitHub Actions checks out in detached HEAD state during releases
# and the default bundler task tries to push refs/heads/HEAD which doesn't exist
Rake::Task['release:source_control_push'].clear
task 'release:source_control_push', [:remote] do |_, args|
  # Only tag and push if not already tagged
  unless Bundler::GemHelper.instance.send(:already_tagged?)
    Bundler::GemHelper.instance.send(:tag_version) do
      remote = args[:remote] || Bundler::GemHelper.instance.send(:default_remote)
      current_branch = `git rev-parse --abbrev-ref HEAD`.strip
      
      # Skip pushing branch if in detached HEAD state (e.g., in GitHub Actions)
      # In this case, only push the tag
      if current_branch != 'HEAD'
        sh "git push #{remote} refs/heads/#{current_branch}"
      end
      
      version_tag = Bundler::GemHelper.instance.send(:version_tag)
      sh "git push #{remote} refs/tags/#{version_tag}"
      Bundler.ui.confirm 'Pushed git commits and release tag.'
    end
  end
end
