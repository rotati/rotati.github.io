require 'spec_helper'

describe "Service Pages" do
  service_page_ids = ['hybridmobileapps', 'nativemobileapps', 'webapps']

  service_page_ids.each do |service_page_id|
    context "within the #{service_page_id} service page section id" do

      before do
        visit "/services/#{service_page_id}"
      end

      it "should have a link to the contact us page" do
        contact_us_link = page.find(:xslt, "//section[id=#{service_page_id}]").find_link("Get In Touch")
        expect(contact_us_link[:href]).to eq '/contact'
      end
    end
  end
end
