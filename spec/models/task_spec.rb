require 'spec_helper'

describe Task do
  let(:user) { FactoryGirl.create(:user) }
  let(:project){user.projects.create!(name: "Example Project")}
  before do
    @task = project.tasks.build(name: "Example Task", status: "done", project_id: 1)
  end

  subject { @task  }

  it { should respond_to(:name) }
  it { should respond_to(:status) }
  it { should respond_to(:project_id) }
  it { should respond_to(:project) }
  its(:project) { should eq project }
  it { should be_valid }
  
  describe "when name is not present" do
    before do 
      @task = Task.new(name: " ", project_id: 1)
    end
    it { should_not be_valid }
  end
  
  describe "when project_id is not present" do
    before do 
      @task = Task.new(name: "Example Task", project_id: nil)
    end
    it { should_not be_valid }
  end
end
