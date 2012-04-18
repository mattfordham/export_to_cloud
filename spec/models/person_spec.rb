require 'spec_helper'

describe Person do
  
  let(:person) {
    Person.create(:first_name => "Jon", :last_name => "Smith", :age => 33, :is_admin => true)
  }
  
  it "should work" do
    pending
  end
  
end
