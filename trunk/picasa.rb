require 'net/http'
require 'open-uri'

class Picasa

   def initialize
      @h = Net::HTTP.new('picasaweb.google.com')
   end

   def get_albums(user_name)
      @resp, data = @h.get("/data/feed/api/user/#{user_name}?kind=album", nil)
      #puts resp, data
      #File.open("albums.xml",'w') { |f| f << data }
      #data =File.open("albums.xml",'r').read
      @albums = data.scan(/<gphoto:name>([^<]+)<\/gphoto:name>/)
      @albums.reverse!
      [@resp,@albums]
   end

   def get_photos(user_name,album_name)
      @resp, data = @h.get("/data/feed/api/user/#{user_name}/album/#{album_name}?kind=photo", nil)
      #puts resp, data
      #File.open("photos.xml",'w') { |f| f << data }
      #data =File.open("photos.xml",'r').read
      @photos = data.scan(/<content type='[^']+' src='([^']+)'><\/content>/)
      [@resp,@photos]
   end

   def download(url,dest)
      if not File.exists?(dest)
         req = Net::HTTP.get_response(URI.parse(url.to_s))
         File.open(dest,'wb') { |f| f << req.body }
      end
   end

end
