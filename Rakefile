
def sh! *args
  sh(*args){}
end

def file? arg
  File.exists? File.expand_path arg
end

PATHOGEN_SOURCE = '~/.vim/autoload/pathogen.vim'
VIMRC           = '~/.vimrc'

# desc "show which shell is used"
task "show_shell" => [] do
  sh "echo $SHELL"
end

namespace :install do
  rule VIMRC do | t |
    File.open t.name, "w" do | f |
      f.puts 'execute pathogen#infect()'
      f.puts 'syntax on'
      f.puts 'filetype plugin indent on'
    end unless file? t.name
  end

  rule PATHOGEN_SOURCE do | t |
    sh! "mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso #{t.name} https://tpo.pe/pathogen.vim" unless
    file? t.name
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
