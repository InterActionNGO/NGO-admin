require 'spec_helper'

describe Admin::HumanitarianScopesController do
  render_views

  let :admin do
    User.create!(
      :email                 => "steve@example.com",
      :name                  => "Admin",
      :password              => "password",
      :password_confirmation => "password"
    )
  end

  let :sector do
    Sector.create!(:name => "Sector #1")
  end

  let :project do
    Project.create!(
      :description             => "Description",
      :end_date                => 1.month.from_now,
      :geographical_scope      => "global",
      :humanitarian            => true,
      :name                    => "Project",
      :primary_organization_id => 1,
      :sectors                 => [sector],
      :start_date              => 1.month.ago
    )
  end

  let :type1 do
    HumanitarianScopeType.create!(:code => "1", :name => "Emergency")
  end

  let :type2 do
    HumanitarianScopeType.create!(:code => "2", :name => "Appeal")
  end

  let :vocab1 do
    HumanitarianScopeVocabulary.create!(:code => "1-2", :name => "Glide")
  end

  let :vocab2 do
    HumanitarianScopeVocabulary.create!(:code => "2-1", :name => "Humanitarian Plan")
  end

  before do
    User.delete_all
    Project.delete_all
    HumanitarianScope.delete_all
    HumanitarianScopeType.delete_all
    HumanitarianScopeVocabulary.delete_all

    project.humanitarian_scopes.create!(
      :humanitarian_scope_type       => type1,
      :humanitarian_scope_vocabulary => vocab1
    )

    Settings.create
    session[:user_id] = admin.id
  end

  context "GET #index" do
    before do
      get :index, :project_id => project.id
    end

    it "responds with success" do
      response.status.should == 200
    end

    it "displays humanitarian scopes" do
      response.body.should =~ /#{type1.name}/
      response.body.should =~ /#{vocab1.name}/
    end
  end

  context "POST #create" do
    context "with valid info" do
      before do
        post :create, :project_id => project.id, :humanitarian_scope => {
          :humanitarian_scope_type_id       => type2.id,
          :humanitarian_scope_vocabulary_id => vocab2.id
        }
      end

      it "responds with redirect" do
        response.status.should == 302
      end

      it "creates a humanitarian scope" do
        project.humanitarian_scopes.count.should == 2
      end
    end

    context "with invalid info" do
      before do
        post :create, :project_id => project.id, :humanitarian_scope => {
          :humanitarian_scope_type_id => type2.id,
        }
      end

      it "responds with success" do
        response.status.should == 200
      end

      it "does not create a humanitarian scope" do
        project.humanitarian_scopes.count.should == 1
      end

      it "includes error message" do
        response.body.should =~ /Humanitarian scope vocabulary can.*t be blank/
      end
    end

    context "with a non-humanitarian project" do
      before do
        project.update_attribute(:humanitarian, false)

        post :create, :project_id => project.id, :humanitarian_scope => {
          :humanitarian_scope_type_id       => type2.id,
          :humanitarian_scope_vocabulary_id => vocab2.id
        }
      end

      it "responds with redirect" do
        response.status.should == 302
      end

      it "does not create a humanitarian scope" do
        project.humanitarian_scopes.count.should == 1
      end
    end
  end

  context "DELETE #destroy" do

  end
end
