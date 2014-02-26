# All Rake tasks in this file can be used by Heroku's Scheduler add-on
namespace :rage do

  task :update_actives => :environment do
    Show.where(active: true).each do |active_show|
      active_show.check_for_new_episodes
    end
  end

end