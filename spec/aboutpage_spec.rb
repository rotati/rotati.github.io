require 'spec_helper'

describe "about page" do
  staff_data =[
    {name: 'Darren', image_filename: 'darren.jpg', link: 'https://linkedin.com/in/jensendarren1'},
    {name: 'Reaksmey', image_filename: 'reaksmey.jpg', link: 'https://www.facebook.com/ymingliang'}
  ]

  before do
    visit "/about/"
  end

  def name_text(social_link)
    social_link.first(:xpath,".//../h5").text
  end

  def image_filename(social_link)
    social_link.first(:xpath,".//..").find("img")['src'].gsub('/images/staff/','')
  end

  describe "displaying all staff data details" do
    staff_data.each do |staff|
      it "should have a social link for #{staff[:name]}" do
        expect(page).to have_link("", href: staff[:link])
      end

      it "should have the name and picture next to the social link" do
        social_link = find("a[href='#{staff[:link]}']")
        expect(name_text(social_link)).to eq staff[:name]
        expect(image_filename(social_link)).to eq staff[:image_filename]
      end
    end
  end
end
