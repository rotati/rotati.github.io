require 'spec_helper'

describe "team page" do
  staff_data =[
    {name: 'Darren', image_filename: 'darren.jpg', link: 'https://linkedin.com/in/jensendarren1'},
    {name: 'Pirun', image_filename: 'pirun.png', link: 'https://www.linkedin.com/profile/edit?locale=en_US&trk=profile-preview'},
    {name: 'Siya', image_filename: 'siya.jpg', link: 'https://www.linkedin.com/profile/view?id=AAkAABR3sVcBGWv8URudmAujytZcJYSVwL5FWuE&authType=NAME_SEARCH&authToken=aOS8&locale=en_US&trk=tyah&trkInfo=clickedVertical%3Amynetwork%2CclickedEntityId%3A343388503%2CauthType%3ANAME_SEARCH%2Cidx%3A1-1-1%2CtarId%3A1442802513294%2Ctas%3Asiya%20ny'},
    {name: 'Phanith', image_filename: 'phanith.jpg', link: 'https://twitter.com/Mphanith'},
    {name: 'Victory', image_filename: 'victory.jpg', link: 'https://www.linkedin.com/in/somethvictory'},
    {name: 'Sinal', image_filename: 'sinal.jpg', link: 'https://www.linkedin.com/in/meassinal'},
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
