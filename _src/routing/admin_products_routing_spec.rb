require "spec_helper"

describe Admin::ProductsController, "routing" do

  describe :admin_products_path do
    let(:path) { admin_products_path  }
    specify { path.should == "/admin/products" }

    describe "on GET" do
      subject { get(path) }
      it { should route_to("admin/products#index")  }
    end

    describe "on POST" do
      subject { post(path) }
      it { should route_to("admin/products#create") }
    end
  end

  describe :admin_product_path do
    let(:id) { 1 }
    let(:path) { admin_product_path(id)  }
    specify { path.should == "/admin/products/#{id}" }

    describe "on GET" do
      subject { get(path) }
      it { should route_to("admin/products#show", :id => id) }
    end

    describe "on PUT" do
      subject { put(path) }
      it { should route_to("admin/products#update", :id => id) }
    end

    describe "on DELETE" do
      subject { delete(path) }
      it { should route_to("admin/products#destroy", :id => id) }
    end
  end

  describe :new_admin_product_path do
    let(:path) { new_admin_product_path  }
    specify { path.should == "/admin/products/new" }

    describe "on GET" do
      subject { get(path) }
      it { should route_to("admin/products#new")  }
    end
  end

  describe :edit_admin_product_path do
    let(:id) { 1 }
    let(:path) { edit_admin_product_path(id) }
    specify { path.should == "/admin/products/#{id}/edit" }

    describe "on GET" do
      subject { get(path) }
      it { should route_to("admin/products#edit", :id => id)  }
    end
  end

end
