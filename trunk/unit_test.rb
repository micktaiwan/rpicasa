require 'test/unit'
require 'picasa'

class TC_Picasa < Test::Unit::TestCase
   def setup
      @p = Picasa.new
      @user_name = 'carofm'
   end

   def teardown
   end

   def test_albums
      @albums = @p.get_albums(@user_name)
      puts @albums.join(', ')
   end
   
   def test_photos
      @photos = @p.get_photos(@user_name, 'Uruguay')
      puts @photos.size
   end
   
   def test_download
      @photos = @p.get_photos(@user_name, 'Uruguay')
      @p.download(@photos[0])
   end
   
end
