require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_title('Sign up') }
        it { should have_content('error') }
      end

      describe "blank name" do
      	before { click_button submit }
      	before {fill_in "Name", with: " "}

      	it {should have_content('Name can\'t be blank')}
      end

      describe "blank email" do
      	before { click_button submit }
      	before {fill_in "Email", with: " "}

      	it {should have_content('Email can\'t be blank')}
      end

      describe "invalid email" do
      	before { click_button submit }
      	before {fill_in "Email", with: "fooblat"}

      	it {should have_content('Email is invalid')}
      end

      describe "taken email" do
        before { @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar") }
        before { @user.save }

        before do
          fill_in "Name",         with: "Example User"
          fill_in "Email",        with: "user@example.com"
          fill_in "Password",     with: "foobar"
          fill_in "Confirmation", with: "foobar"
        end
        before { click_button submit }

      	it {should have_content('Email has already been taken')}
      end

      describe "short password" do
      	before { fill_in "Password", with: "f" * 5 }
        before {click_button submit}

        it {should have_content('too short')}
      end

      describe "blank password" do
      	before { fill_in "Password", with: " " }
        before {click_button submit}

        it {should have_content('Password can\'t be blank')}
      end

      describe "blank password" do
      	before { fill_in "Password", with: "asdfasdf" }
      	before { fill_in "Password", with: "asdfasdffffff" }
        before {click_button submit}

        it {should have_content('doesn\'t match')}
      end


    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Sign out') }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end
    end
  end

end