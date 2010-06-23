module Heroku::Command
  class Base
    def extract_app_in_dir(dir)
      return unless remotes = git_remotes(dir)

      if remote = extract_option('--remote')
        remotes[remote]
      else
        remotes.each do |remote, app|
          return app if remote == current_branch
        end

        return remotes.values.first if remotes.size == 1

        puts "(unable to resolve app name from git remotes)"
      end
    end

    def current_branch
      @current_branch ||= current_branch!
    end

    def current_branch!
      return unless m = `git branch`.match(/^\* (.+)$/)
      m[1]
    end
  end
end
