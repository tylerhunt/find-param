require File.join(File.dirname(__FILE__), 'test_helper')

class FindByParamTest < Test::Unit::TestCase
  def setup
    BlogPost.create(:slug => 'adam-west', :title => 'Adam West')
    BlogPost.create(:slug => 'burt-ward', :title => 'Burt Ward')
    BlogPost.send(:define_find_param, 'slug')
  end
  
  def teardown
    BlogPost.delete_all
  end
  
  def test_plugin_loaded_correctly
    assert_kind_of FindByParam::ClassMethods, BlogPost
    assert BlogPost.respond_to?(:find_by_param)
  end
  
  def test_returns_valid_data
    bp = BlogPost.find(:first, :conditions => 'slug = "adam-west"')
    assert_equal BlogPost.find_by_param('adam-west'), bp
  end
  
  def test_can_define_find_parameter
    BlogPost.send('define_find_param', 'title')
    bp = BlogPost.find(:first, :conditions => {:slug => 'adam-west'})
    assert_equal BlogPost.find_by_param('Adam West'), bp
  end
  
  def test_correctly_goes_to_param
    bp = BlogPost.find(:first, :conditions => {:slug => 'adam-west'})
    assert_equal bp.to_param, 'adam-west'
  end
  
  def test_raises_on_not_found_if_specified
    BlogPost.send(:define_find_param, 'slug', :raise_on_not_found => true)
    assert_raises ActiveRecord::RecordNotFound do
      BlogPost.find_by_param('in ur tests, failing')
    end
  end
  
  def test_raises_column_not_found_error_when_given_undefined_column
    assert_raise(FindByParam::ColumnNotFoundError) do
      BlogPost.send(:define_find_param, 'bad_column_name')
    end
    assert_kind_of FindByParam::Error, FindByParam::ColumnNotFoundError.new
  end
  
end