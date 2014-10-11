
#--------------------------------------------------------------------
#
# Rakefile to implement Travis-CI installation and tests
#
#---------------------------------------------------------------------

require 'tilt'


#
# --- Helpers
#
def dir? arg
  File.directory? expand arg
end

def expand arg
  File.expand_path arg
end

def file? arg
  File.exists? expand arg
end

def mdir( *args )
  rule( *args ) do | ft |
    sh "mkdir -p #{ft.name}" unless dir? ft.name
  end
end

def make_file file, &blk
  rule file do | ft |
    unless file? file
      puts "[rake]: making file #{ft.name}"
      blk.( ft )
    end
  end
end

def sh! *args
  sh(*args){}
end

#
# --- Configuration
#
PROJECT_HOME    = expand '.'
TMPDIR          = expand 'tmp'
HOMEDIR         = TMPDIR
PATHOGEN_HOME   = expand 'tmp/.vim/bundle'
VIMRC           = File.join TMPDIR, '.vimrc'
VIMDIR          = File.join TMPDIR, '.vim'
VIM_AUTOLOAD    = File.join VIMDIR, 'autoload'
VIMRC_TEMPLATE  = 'vimrc_template.str'
PATHOGEN_SOURCE = File.join VIM_AUTOLOAD, 'pathogen.vim'

mdir TMPDIR
mdir VIM_AUTOLOAD
mdir PATHOGEN_HOME

def home_for plugin
  File.join( PATHOGEN_HOME, plugin.to_s )
end

#
# --- Debugging (delete when stable)
#
# desc "show which shell is used"
# task "show_shell" => [] do
#   sh "echo $SHELL"
# end

# desc "where are we"
# task :where do
#   p PATHOGEN_HOME
# end

desc "check settings of vim for tests"
task :check_vim => ['install:clean', :vim_no_tests]

task :vim_no_tests => :installation do
  sh "HOME=#{TMPDIR} vim"
  # sh "vim -u #{VIMRC}"
end

desc "w/a for a bug I am too tiered to work at"
task :rebuild_vimrc => [:remove_vimrc, VIMRC]

task :remove_vimrc do
  sh! "rm #{VIMRC}"
end


#
# --- Tasks
#
namespace :install do
  rule VIMRC => VIMRC_TEMPLATE do | t |
    File.open t.name, "w" do | f |
    f.write Tilt.new( VIMRC_TEMPLATE ).render
  end
  print File.read t.name
  end

  make_file PATHOGEN_SOURCE do | t |
    sh "curl -LSso #{t.name} https://tpo.pe/pathogen.vim"
  end

  desc "install pathogen"
  task :pathogen => [VIM_AUTOLOAD, PATHOGEN_HOME, PATHOGEN_SOURCE] do
    puts "[rake]: installing pathogen"
  end

  desc "install timl into #{home_for :timl}" 
  task :timl do
    sh! "git clone https://github.com/tpope/timl #{home_for :timl}"
  end

  desc "install tim (symbolic links to project in #{home_for :tim})"
  task :tim do
    sh! "mkdir -p #{home_for :tim}"
    sh! "ln -s #{File.join PROJECT_HOME, 'autoload'} #{home_for :tim}"
    sh! "ln -s #{File.join PROJECT_HOME, 'plugin'} #{home_for :tim}"
  end

  desc "removes installed assets (pathogene, timl), needed to force reinstall"
  task :clean do
    sh 'rm -rf tmp'
  end
end # namespace :install


desc "installation job for travis"
# task :installation => ["install:pathogen", "install:timl",  "install:tim"] do
task :install => ["install:pathogen", "install:timl",  "install:tim", VIMRC] do
  puts "[rake]: installation finished"
end

desc "launch vim with test runner ane analyze results"
task test: [ :run_tests, :analyze_tests] 

task :run_tests => TMPDIR do  
  sh "HOME=#{HOMEDIR} vim -S test/run.vim"
  # sh "vim -u tmp/.vimrc -S test/run.vim"
end
task :analyze_tests do
  sh "ruby analyze_tests.rb" do | _, result |
    exit result.exitstatus
  end
end
