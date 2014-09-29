require 'spec_helper'

describe Project do
  let(:user) { FactoryGirl.create(:user) }
  before do
    @project = user.projects.build(name: "Example Project")
  end

  subject { @project  }

  it { should respond_to(:name) }
  it { should respond_to(:user) }
  its(:user) { should eq user }
  
  it { should be_valid }
  
  describe "when name is not present" do
    before do 
      @project = Project.new(name: " ", user_id: 1)
    end
    it { should_not be_valid }
  end
  
  describe "when user_id is not present" do
    before do 
      @project = Project.new(name: "Example Project", user_id: nil)
    end
    it { should_not be_valid }
  end
  
  describe "with name that is too long" do
      before { @project.name = "a" * 141 }
       it { should_not be_valid }
  end
  
  describe "with default name" do
      before { @project_with_def_name = Project.new(user_id: 1)}
      it { should be_valid }
  end
  
end
