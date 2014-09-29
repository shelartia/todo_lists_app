require 'spec_helper'

describe "Projects" do
  subject { page }
  
  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit todolists_path
    end

    it { should have_title('My TODO lists') }
  end
end
