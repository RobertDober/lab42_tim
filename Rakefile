#--------------------------------------------------------------------
#
# Rakefile to implement Travis-CI installation and tests
#
#---------------------------------------------------------------------

#
# --- Helpers
#
def sh! *args
  sh(*args){}
end

def expand arg
  File.expand_path arg
end

def file? arg
  File.exists? expand arg
end

def make_file file, &blk
  rule file do | ft |
    blk.( ft ) unless file? file
  end
end

#
# --- Configuration
#
PATHOGEN_HOME   = expand '~/.vim/bundle'
VIMRC           = expand '~/.vimrc'
VIM_AUTOLOAD    = expand '~/.vim/autoload'
PATHOGEN_SOURCE = File.join VIM_AUTOLOAD, 'pathogen.vim'

# desc "show which shell is used"
# task "show_shell" => [] do
#   sh "echo $SHELL"
# end

namespace :install do
  make_file VIMRC do | t |
    File.open t.name, "w" do | f |
      f.puts 'execute pathogen#infect()'
      f.puts 'syntax on'
      f.puts 'filetype plugin indent on'
    end
    print File.read t.name
  end

  make_file PATHOGEN_SOURCE do | t |
    sh! "mkdir -p #{VIM_AUTOLOAD} #{PATHOGEN_HOME} && curl -LSso #{t.name} https://tpo.pe/pathogen.vim"
    sh! "git clone https://github.com/tpope/timl #{File.join PATHOGEN_HOME, "timl"}"
  end

  desc "prepare installation directory for pathogen"
  task :prepare_pathogen => [PATHOGEN_SOURCE, VIMRC] do

  end

  desc "install pathogen"
  task :pathogen => :prepare_pathogen do
    puts "installing pathogen"
  end
end # namespace :install

desc "installation job for travis"
task :installation => ["install:pathogen"] do
  puts "installation finished"
end

desc "launch vim with test runner"
task :test do  
  sh "cd test && vim -S run.vim"
end
