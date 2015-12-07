require 'spec_helper'

describe "Homepage" do

  before :each do
    visit "/index.html"
  end

  it "slightly obfuscate the email" do
    expect(page).to have_content("info(at)rotati.com")
  end

  describe "slider learn more links" do
    service_page_ids = ['hybridmobileapps', 'nativemobileapps']
    service_page_another_id = ['webapps']
    service_page_ids.each do |service_page_id|
      describe "#{service_page_id} slider" do
        it "should link to the #{service_page_id} service page" do
          learn_more_link = page.find("##{service_page_id}").find_link("Learn More")
          learn_more_link.click

          expect(current_path).to eq "/services/#{service_page_id}"
          expect(page).to have_content(service_page_id.gsub('mobileapps', ' mobile apps').split.map(&:capitalize).join(' '))
        end
      end
    end
    service_page_another_id.each do |service_page_another_id|
      describe "#{service_page_another_id} slider" do
        it "should link to the #{service_page_another_id} service page" do
          learn_more_link = page.find("##{service_page_another_id}").find_link("Learn More")
          learn_more_link.click

          expect(current_path).to eq "/services/#{service_page_another_id}"
          expect(page).to have_content(service_page_another_id.gsub('apps', ' apps').split.map(&:capitalize).join(' '))
        end
      end
    end
  end
end
