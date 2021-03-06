require 'spec_helper'

describe RemoteBook::Amazon do
  before(:each) do
    RemoteBook::Amazon.associate_keys = {:associates_id => 'foo',
                                         :key_id => 'bar',
                                         :secret_key => 'baz'}
  end
  it "should set large_image on successful get" do
    FakeWeb.register_uri(:get, %r|http://ecs\.amazonaws\.com/(.*)|, :body => load_file("amazon_1433506254.xml"))
    a = RemoteBook::Amazon.find_by_isbn("1433506254")
    a.large_image.should == "http://ecx.images-amazon.com/images/I/41xMfBAsMnL.jpg"
    a.medium_image.should == "http://ecx.images-amazon.com/images/I/41xMfBAsMnL._SL160_.jpg"
  end
  
  it "find_by_isbn should return false when error code returned by web service" do
    FakeWeb.register_uri(:get, %r|http://ecs\.amazonaws\.com/(.*)|, :body => "Error", :status => ["404", "not found"])
    a = RemoteBook::Amazon.find_by_isbn("unicorn")
    a.should be_false
  end

end
