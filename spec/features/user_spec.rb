require 'spec_helper'

feature "User signs in" do

before(:each) do
	User.create(:email => "test@test.com",
							:password => 'test',
							:password_confirmation => 'test')
end

scenario "with correct credentials" do 
	visit '/'
	expect(page).not_to have_content("Welcome, test@test.com")
	sign_in('test@test.com', 'test')
	expect(page).to have_content("Welcome, test@test.com")
end

scenario "with incorrect credentials" do
	visit '/'
	expect(page).not_to have_content("Welcome, test@test.com")
	sign_in('test@test.com', 'wrong')
	expect(page).not_to have_content("Welcome, test@test.com")
end

def sign_in(email, password)
	visit '/session.new'
	fill_in 'email', :with => email
	fill_in 'password', :with => password
	click_button 'Sign in'
end














feature "User signs up" do


scenario "when being logged out" do
  visit '/users/new'
 	lambda{sign_up }.should change(User, :count).by(1)
  expect(User.count).to eq(1)
	expect(page).to have_content("Welcome, gio@linda.com")
	expect(User.first.email).to eq("gio@linda.com")
end


scenario "with a password that does not match" do
	lambda{sign_up('gio@linda.com', 'pass', 'wrong')}.should change(User, :count).by(0)
	expect(current_path).to eq('/users')
	expect(page).to have_content("Sorry, your passwords don't match")
end

scenario "with an email that is already registered" do 
	lambda{ sign_up }.should change(User, :count).by(1)
	lambda{ sign_up }.should change(User, :count).by(0)
	expect(page).to have_content("This email is already taken")
end


def sign_up(email = "gio@linda.com", password = "oranges!", password_confirmation = 'oranges!')
    visit '/users/new'
    fill_in :email, :with => email
    fill_in :password, :with => password
    fill_in :password_confirmation, :with => password_confirmation
    click_button "Sign Up"
end








end
