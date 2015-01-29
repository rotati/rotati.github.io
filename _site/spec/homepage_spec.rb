require 'spec_helper'

describe "Homepage" do

  before :each do
    visit "/index.html"
  end

  it "slightly obfuscate the email" do
    expect(page).to have_content("info(at)rotati.com")
  end
end
