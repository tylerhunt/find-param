$LOAD_PATH.unshift 'lib/'

require 'rubygems'
require 'multi_rails_init'
require 'action_controller/test_process'
require 'test/unit'
require 'find_by_param'

begin
  require 'redgreen'
rescue LoadError
  nil
end

RAILS_ROOT = '.'    unless defined? RAILS_ROOT
RAILS_ENV  = 'test' unless defined? RAILS_ENV


ActiveRecord::Base.send(:extend, FindByParam::ClassMethods)
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")
ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Schema.define(:version => 1) do
  create_table :blog_posts do |t|
    t.column :slug, :string
    t.column :title, :string
  end
end

class BlogPost < ActiveRecord::Base
end