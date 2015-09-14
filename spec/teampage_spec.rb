require 'spec_helper'

describe "team page" do
  staff_data =[
    {name: 'Darren', image_filename: 'darren.jpg', link: 'https://linkedin.com/in/jensendarren1'},
    {name: 'Ben', image_filename: 'ben.jpg', link: 'https://www.facebook.com/ben.skelton.503?fref=ts'},
    {name: 'Dave', image_filename: 'david-wilkie.jpg', link: 'https://www.facebook.com/davidcwilkie?fref=ts'},
    {name: 'Bunhouth', image_filename: 'bunhouth.jpg', link: 'https://www.facebook.com/bun.houth.7?fref=ts'},
    {name: 'Sim', image_filename: 'sim.jpg', link: 'https://www.facebook.com/uysim?fref=ts'},
    {name: 'Vicheth', image_filename: 'vicheth.jpg', link: 'https://www.facebook.com/vicheth.info?fref=ts'},
    {name: 'Kosal', image_filename: 'kosal.jpg', link: 'https://www.facebook.com/ma.c.kosal?fref=ts'},
    {name: 'Pirun', image_filename: 'pirun.png', link: 'https://www.facebook.com/profile.php?id=100009053969884'},
    {name: 'Siya', image_filename: 'siya.jpg', link: 'https://www.facebook.com/siya.ny01?fref=ts'},
    {name: 'Phanith', image_filename: 'phanith.jpg', link: 'https://twitter.com/Mphanith'},

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
