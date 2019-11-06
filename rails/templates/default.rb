simple = yes?("Should we do a simple install?")
gem 'mocha', :version => '>= 0.9.5', :env => 'test'
gem 'factory_girl', :lib => 'factory_girl', :source => 'http://gemcutter.org', :version => '>= 1.2.0', :env => 'test'
gem 'shoulda', :lib => 'shoulda/rails', :source => 'http://gemcutter.org', :env => 'test'
gem 'authlogic'
gem "formtastic", :source => 'http://gemcutter.org'
gem 'validation_reflection'
unless simple
  gem "matthuhiggins-foreigner", :lib => "foreigner"
end

unless simple
  compass = yes?("Should compass be installed?")
  if compass
    gem "haml", :version => ">=2.2.16"
    gem "compass", :version => ">= 0.8.17"
  end

  if yes?("Should searchlogic be installed?")
    gem "searchlogic"
    gem "will_paginate"
  else
    gem("will_paginate") if yes?("Should will_paginate be installed?")
  end

  gem("paperclip") if yes?("Should paperclip be installed?")
end

rake 'gems:unpack', :env => "test"


unless simple
  plugin 'hoptoad_notifier', :git => 'git://github.com/thoughtbot/hoptoad_notifier.git'
end
plugin 'model_generator_with_factories', :git => 'git://github.com/vigetlabs/model_generator_with_factories.git'
plugin 'asset_packager', :git => 'git://github.com/sbecker/asset_packager.git'
unless simple
  plugin 'helper_me_test', :git => 'git://github.com/vigetlabs/helper_me_test.git'
  plugin 'blue-ridge', :git => 'git://github.com/brianjlandau/blue-ridge.git'
end
plugin 'jrails', :git => 'git://github.com/aaronchi/jrails.git'
plugin 'seed-fu', :git => 'git://github.com/mbleigh/seed-fu.git'
unless simple
  plugin 'serialize_with_options', :git => 'git://github.com/vigetlabs/serialize_with_options.git'
  plugin 'action_button', :git => 'git://github.com:vigetlabs/action_button.git'
end


if !simple && compass
  # Require compass during plugin loading
  file 'vendor/plugins/compass/init.rb', <<-CODE
  # This is here to make sure that the right version of sass gets loaded (haml 2.2) by the compass requires.
  require 'compass'
  CODE

  run "haml --rails ."
  run "compass --rails -f blueprint . --css-dir=public/stylesheets/compiled --sass-dir=app/stylesheets"
end

# clean up
run 'rm -rf public/images/rails.png log/* test/fixtures'
inside 'public' do
  run 'rm -f index.html robots.txt'
end

run 'cp config/database.yml config/database.yml.example'

file '.gitignore', %q[
.DS_Store
coverage/*
log/*.log
db/*.db
db/*.sqlite3
tmp/**/*
config/database.yml
]
run 'touch tmp/.gitignore log/.gitignore public/stylesheets/.gitignore'

# install jrails javascripts
rake 'jrails:js:install'
rake 'jrails:js:scrub'

rakefile 'rcov_tasks.rake' do
<<-TASK
begin
  require 'rcov/rcovtask'
rescue LoadError
  # do nothing
end

if Object.const_defined?(:Rcov)
  namespace :test do
    Rcov::RcovTask.new(:rcov => "db:test:prepare") do |t|
      t.libs << 'test'
      t.test_files = FileList['test/**/*_test.rb']
      t.rcov_opts = %w[--sort coverage -T --only-uncovered --rails]
      t.rcov_opts << '-x "\/opt\/local\/lib/ruby"'
      t.rcov_opts << '-x "\/System\/Library\/"'
      t.rcov_opts << '-x "\/Library\/Ruby\/"'
    end

    desc "Generate code Coverage with rcov and open report"
    task :coverage => "test:rcov" do
      system "open coverage/index.html" if PLATFORM['darwin']
    end
    
    namespace :units do
      Rcov::RcovTask.new(:rcov => "db:test:prepare") do |t|
        t.libs << 'test'
        t.test_files = FileList['test/unit/**/*_test.rb']
        t.output_dir = 'unit_coverage'
        t.rcov_opts = %w[--sort coverage -T --only-uncovered --rails]
        t.rcov_opts << '-x "\/opt\/local\/lib/ruby"'
        t.rcov_opts << '-x "\/System\/Library\/"'
        t.rcov_opts << '-x "\/Library\/Ruby\/"'
        t.rcov_opts << '-x "app\/helpers"'
        t.rcov_opts << '-x "app\/controllers"'
        t.rcov_opts << '-x "lib"'
      end
      
      desc "Generate code Coverage for Unit Tests with rcov and open report"
      task :coverage => "test:units:rcov" do
        system "open unit_coverage/index.html" if PLATFORM['darwin']
      end
    end
    
    namespace :functionals do
      Rcov::RcovTask.new(:rcov => "db:test:prepare") do |t|
        t.libs << 'test'
        t.test_files = FileList['test/functional/**/*_test.rb']
        t.output_dir = 'functional_coverage'
        t.rcov_opts = %w[--sort coverage -T --only-uncovered --rails]
        t.rcov_opts << '-x "\/opt\/local\/lib/ruby"'
        t.rcov_opts << '-x "\/System\/Library\/"'
        t.rcov_opts << '-x "\/Library\/Ruby\/"'
        t.rcov_opts << '-x "app\/helpers"'
        t.rcov_opts << '-x "app\/models"'
        t.rcov_opts << '-x "lib"'
      end
      
      desc "Generate code Coverage for Unit Tests with rcov and open report"
      task :coverage => "test:functionals:rcov" do
        system "open functional_coverage/index.html" if PLATFORM['darwin']
      end
    end
    
    namespace :coverage do
      desc "Generate code Coverage with rcov and open report"
      task :all => ["test:rcov", "test:functionals:rcov", "test:units:rcov"] do
        system "open coverage/index.html" if PLATFORM['darwin']
        system "open unit_coverage/index.html" if PLATFORM['darwin']
        system "open functional_coverage/index.html" if PLATFORM['darwin']
      end
    end
  end
end
TASK
end
  

file 'test/test_helper.rb', %q{ENV["RAILS_ENV"] = "test"
$:.push(File.dirname(__FILE__))
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require "authlogic/test_case"

class ActiveSupport::TestCase

  protected
  
  def destroy_and_nil(*args)
    args.each do |ivar|
      unless instance_eval("@#{ivar}.nil?")
        instance_eval("@#{ivar}.destroy")
        instance_eval("@#{ivar} = nil")
      end
    end
  end
end

class ActionController::TestCase
  setup :activate_authlogic
  
  protected
  
  def login_as(user)
    unless user.is_a? User
      user = User.find_by_email(user)
    end
    UserSession.create(user)
  end
  
  def logout
    if controller.send(:current_user_session)
      controller.send(:current_user_session).destroy
      controller.instance_eval('@current_user_session = nil')
    end
  end
end  
}

file 'public/javascripts/jquery.livequery.js', open('http://github.com/brandonaaron/livequery/raw/master/jquery.livequery.js').read
file 'public/javascripts/jquery.lowpro.js', open('http://gist.github.com/raw/121590/fa62a834ddce75aca4ef3e2e3b313522510e9538/jquery.lowpro.js').read
unless simple
  initializer 'slugize.rb', open('http://gist.github.com/raw/22618/e1d28a6382279b649f42293c424293213dd78f42/inflectors.rb').read
end
initializer 'datetime_formats.rb', %q{Date::DATE_FORMATS[:us_date] = "%m/%d/%Y"
Time::DATE_FORMATS[:us_date_time] = "%m/%d/%Y %l:%M %p"
}


generate :session, 'UserSession'
generate :resource, 'User', 'login:string', 'email:string', 'crypted_password:string', 'password_salt:string', 'persistence_token:string'
generate :controller, 'user_sessions'
generate :blue_ridge unless simple
generate :formtastic

inside 'app/helpers' do
  run 'rm -f user_sessions_helper.rb users_helper.rb'
end

rake 'asset:packager:create_yml'

gsub_file 'app/controllers/application_controller.rb', /#\s*(filter_parameter_logging :password)/, '\1'
unless simple
  gsub_file 'app/controllers/application_controller.rb', /(class ApplicationController < ActionController::Base)/, "\\1\n  include HoptoadNotifier::Catcher"
end
gsub_file 'app/controllers/application_controller.rb', /^end/, %q{
  before_filter :store_location
  helper_method :current_user, :logged_in?, :creative_format_form_partial
  
  layout proc{ |controller| controller.request.xhr? ? false : "application" }
  
  protected
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def logged_in?
    !current_user_session.blank?
  end

  def login_required
    unless current_user
      flash[:notice] = "You must be logged in to access this page"
      redirect_to login_url
      return false
    end
    true
  end

  def require_no_login
    if logged_in?
      flash[:notice] = "You must be logged out to access this page"
      redirect_to root_url
      return false
    end
  end

  def store_location
    if request.request_method == :get and !request.xhr?
      session[:return_to] = request.request_uri
    end
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
end}

gsub_file 'app/controllers/user_sessions_controller.rb', /(class UserSessionsController < ApplicationController)/, %q[\\1
  skip_before_filter :store_location
  before_filter :require_no_login, :only => [:new, :create]
  before_filter :login_required, :only => [:destroy]
]

gsub_file 'app/controllers/users_controller.rb', /(class UsersController < ApplicationController)/, %q[\\1
  skip_before_filter :store_location, :only => [:new, :create]
  before_filter :login_required, :only => [:edit, :update, :destroy]
]

google_jquery_helper = %q[
  def google_jquery_script_tags
    javascript_include_tag 'http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js',
                           'http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/jquery-ui.min.js'
  end
]
gsub_file 'app/helpers/application_helper.rb', /(module ApplicationHelper)/, "\\1\n#{google_jquery_helper}"

gsub_file 'config/initializers/new_rails_defaults.rb', /(ActiveRecord\:\:Base.include_root_in_json = )true/, "\\1 false"

route 'map.resource :account, :controller => "users"'
route "map.login    '/login',    :controller => 'user_sessions', :action => 'new'"
route "map.logout   '/logout',   :controller => 'user_sessions', :action => 'destroy'"
route "map.register '/register', :controller => 'user',          :action => 'new'"

capify!

file 'config/deploy.rb', %q[
set :application, "[YOUR_APP_NAME]"
set :deploy_to, "/var/www/#{application}"
set :use_sudo, false
set :repository,  "[YOUR_REPO_URL]"
set :scm, :git
set :branch, "origin/master"
set :migrate_target, :current

set :user, "[YOUR_DEPLOY_USERNAME]"

role :web, "your.server.com"
role :app, "your.server.com"
role :db,  "your.server.com", :primary => true

set(:latest_release)  { fetch(:current_path) }
set(:release_path)    { fetch(:current_path) }
set(:current_release) { fetch(:current_path) }

set(:current_revision)  { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:latest_revision)   { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:previous_revision) { capture("cd #{current_path}; git rev-parse --short HEAD@{1}").strip }

after  "deploy:update_code",  "app:symlinks"
after  "deploy:update_code",  "app:asset_packager_build"

namespace :deploy do
  desc "Deploy"
  task :default do
    update
    restart
  end

  desc "Setup a GitHub-style deployment."
  task :setup, :except => { :no_release => true } do
    dirs = [deploy_to, shared_path]
    dirs += shared_children.map { |d| File.join(shared_path, d) }
    run "#{try_sudo} mkdir -p #{dirs.join(' ')} && #{try_sudo} chmod g+w #{dirs.join(' ')}"
    run "git clone #{repository} #{current_path}"
  end

  task :update do
    transaction do
      update_code
    end
  end

  desc "Update the deployed code."
  task :update_code, :except => { :no_release => true } do
    run "cd #{current_path}; git fetch origin; git reset --hard #{branch}"
    finalize_update
  end

  desc "Update the database (overwritten to avoid symlink)"
  task :migrations do
    update_code
    migrate
    restart
  end

  desc "Restart passenger with restart.txt"
  task :restart, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  namespace :rollback do
    desc "Moves the repo back to the previous version of HEAD"
    task :repo, :except => { :no_release => true } do
      set :branch, "HEAD@{1}"
      deploy.default
    end

    desc "Rewrite reflog so HEAD@{1} will continue to point to at the next previous release."
    task :cleanup, :except => { :no_release => true } do
      run "cd #{current_path}; git reflog delete --rewrite HEAD@{1}; git reflog delete --rewrite HEAD@{1}"
    end

    desc "Rolls back to the previously deployed version."
    task :default do
      rollback.repo
      rollback.cleanup
    end
  end
end  

namespace :app do
  desc "Make symlinks"
  task :symlinks do
    run "ln -nfs #{shared_path}/config/database.yml #{current_path}/config/database.yml"
  end

  desc "Compess CSS & Javascript"
  task :asset_packager_build do
    run "cd #{current_path}; #{rake} asset:packager:build_all"
  end
end
]

rake 'rails:freeze:gems'

git :init
