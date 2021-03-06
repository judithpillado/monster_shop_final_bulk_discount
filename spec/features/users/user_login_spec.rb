require 'rails_helper'

RSpec.describe 'User Login Spec' do
  describe 'When I visit the login page' do
    describe 'I can log in with valid credentials email and password' do

      it 'If I am a regular user, I am redirected to my profile page. A flash message will confirm I am logged in' do
        user = create(:user, role: 0)
        visit '/login'
        fill_in :email, with: user.email
        fill_in :password, with: user.password
        click_button 'Log In'
        expect(current_path).to eq("/profile")
        expect(page).to have_content("You are now logged in!")
      end

      it 'If I am a merchant user, I am redirected to my merchant dashbpard page. A flash message will confirm I am logged in' do
        user = create(:user, role: 1, merchant: create(:merchant))
        visit '/login'
        fill_in :email, with: user.email
        fill_in :password, with: user.password
        click_button 'Log In'
        expect(current_path).to eq("/merchant/dashboard")
        expect(page).to have_content("You are now logged in!")
      end

      it 'If I am a admin user, I am redirected to my admin dashboard page. A flash message will confirm I am logged in' do
        user = create(:user, role: 2)
        visit '/login'
        fill_in :email, with: user.email
        fill_in :password, with: user.password
        click_button 'Log In'
        expect(current_path).to eq("/admin/dashboard")
        expect(page).to have_content("You are now logged in!")
      end
    end

    describe 'I cannot log in with bad credentials' do
      it "Submitting invalid credentials redirects me to the login page and displays a flash message" do
        user = create(:user)
        visit '/login'
        fill_in :email, with: user.email
        fill_in :password, with: "this-is-wrong"
        click_button 'Log In'
        expect(current_path).to eq('/login')
        expect(page).to have_content('Wrong email or password entered - please try logging in again.')
      end
    end

    describe 'Users who are logged in already are redirected' do
      it "If I am a regular user, I am redirected to my profile page and I see a flash message that tells me I am already logged in" do
        user = create(:user, role: 0)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

        visit '/login'
        expect(current_path).to eq("/profile")
        expect(page).to have_content("You are already logged in.")
      end

      it "If I am a merchant user, I am redirected to my merchant dashboard page and I see a flash message that tells me I am already logged in" do
        user = create(:user, role: 1, merchant: create(:merchant))
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

        visit '/login'
        expect(current_path).to eq("/merchant/dashboard")
        expect(page).to have_content("You are already logged in.")
      end

      it "If I am an admin user, I am redirected to my admin dashboard page and I see a flash message that tells me I am already logged in" do
        user = create(:user, role: 2)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

        visit '/login'
        expect(current_path).to eq("/admin/dashboard")
        expect(page).to have_content("You are already logged in.")
      end
    end
  end
end
