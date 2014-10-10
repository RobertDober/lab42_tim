
def sh! *args
  sh(*args){}
end

def expand arg
  case arg
  when Enumerable
    arg.map{ |f| expand f }
      .join " "
  else
    File.expand_path arg
  end
end

def file? arg
  File.exists? expand arg
end

def make_file file, &blk
  rule file do | ft |
    blk.( ft ) unless file? file
  end
end

PATHOGEN_SOURCE = expand '~/.vim/autoload/pathogen.vim'
VIMRC           = expand '~/.vimrc'

# desc "show which shell is used"
task "show_shell" => [] do
  sh "echo $SHELL"
end

namespace :install do
  make_file VIMRC do | t |
    File.open t.name, "w" do | f |
      f.puts 'execute pathogen#infect()'
      f.puts 'syntax on'
      f.puts 'filetype plugin indent on'
    end
  end

  make_file PATHOGEN_SOURCE do | t |
    sh! "mkdir -p #{expand %w{~/.vim/autoload ~/.vim/bundle}} && curl -LSso #{t.name} https://tpo.pe/pathogen.vim"
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
end
# - cd ~/.vim/bundle && git clone https://github.com/tpope/timl
# - cd -
