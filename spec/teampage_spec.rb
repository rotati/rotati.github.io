require 'spec_helper'

describe "team page" do
  staff_data =[
    {name: 'Darren', image_filename: 'darren.jpg', link: 'https://linkedin.com/in/jensendarren1'},
    {name: 'Pirun', image_filename: 'pirun.JPG', link: 'https://www.linkedin.com/in/seng-pirun-87417097'},
    {name: 'Siya', image_filename: 'siya.JPG', link: 'https://www.linkedin.com/in/siya-ny-24700097'},
    {name: 'Phanith', image_filename: 'phanith.JPG', link: 'https://twitter.com/Mphanith'},
    {name: 'Victory', image_filename: 'victor.jpeg', link: 'https://www.linkedin.com/in/somethvictory'},
    {name: 'Samnang', image_filename: 'samnang.jpg', link: 'https://www.linkedin.com/profile/view?id=AAkAAAG77P8B1DnkRG5HCXcZo7f5ZAR36ereH1U&authType=NAME_SEARCH&authToken=8Ffo&locale=en_US&trk=tyah&trkInfo=clickedVertical%3Amynetwork%2CclickedEntityId%3A29093119%2CauthType%3ANAME_SEARCH%2Cidx%3A1-4-4%2CtarId%3A1442216698377%2Ctas%3Asamnang'},


  ]

  before do
    visit "/team/"
  end

  def name_text(social_link)
    social_link.first(:xpath,".//../strong").text
  end

  def image_filename(social_link)
    social_link.first(:xpath,".//..").find("img")['src'].gsub('/images/staff/','')
  end

  describe "displaying all staff data details" do
    staff_data.each do |staff|
      it "should have a social link for #{staff[:name]}" do
        expect(page).to have_link("", href: staff[:link])
      end

      it "should have #{staff[:name]}'s name and picture next to the social link" do
        social_link = find("a[href='#{staff[:link]}']")
        expect(name_text(social_link)).to eq staff[:name]
        expect(image_filename(social_link)).to eq staff[:image_filename]
      end
    end
  end
end
