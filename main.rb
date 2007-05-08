require 'picasa'
require 'FileUtils'

class Fixnum

   def two_digits
      return self.to_s if self >= 10
      return '0'+self.to_s
   end

end


class PMain < Picasa # < TextPrompt

   attr_accessor :user_name
   
   def prompt
      while true
         print ">"
         line = gets.chomp
         commands = line.split(' ')
         case commands.shift
            when 'user'
               @user_name = commands.shift
               puts "user is now '#@user_name'"
            when 'albums'
               if(@user_name==nil)
                  puts 'change the user with the command "user"'
                  next
               end
               get_albums(@user_name)
               if(@resp.code != '200')
                  puts "There was an error (#{resp.message}) downloading albums names. Maybe the user #{@user_name} does not exists ?"
                  next
               end
               puts @albums.join(', ')
            when 'dl'
               if(@user_name==nil)
                  puts 'change the user with the command "user"'
                  next
               end
               @album_name = commands.shift
               dl_album(@album_name)
            when 'dlall'
               if(@user_name==nil)
                  puts 'change the user with the command "user"'
                  next
               end
               get_albums(@user_name) if(@albums==nil)
               puts @albums.join(', ')
               @albums.each_with_index { |a,i| puts "downloading #{a}..."; dl_album(a,(i+1).two_digits) }
            when 'quit'
               break
            else
               puts "unknown command: #{line}"
         end
      end
   end

   def help
      puts "user: change user"
      puts "albums: list albums"
      puts "dl: download album"
      puts "dlall: download all albums photos"
   end

private

   def dl_album(album_name,index='')
      path = "#{@user_name}/#{album_name}"
      if(File.exists?(path+"/#{index}#{album_name}_01.jpg"))
         print "#{album_name} seems to be already downloaded, continue ? [Y/N]"
         r = gets.chomp
         return if(r!='Y')
      end
      get_photos(@user_name,album_name)
      if(@resp.code != '200')
         puts "There was an error (#{@resp.message}) downloading photos. Maybe the user #{@user_name} or the album #{@album_name} do not exist ?"
         return
      end
      s = @photos.size
      puts "#{s} photos"
      FileUtils.mkdir_p "#{@user_name}"
      FileUtils.mkdir_p path
      1.upto(s) { |i|
         print i,','
         download(@photos[i-1],"#{path}/#{index}#{album_name}_#{i.two_digits}.jpg")
         }
      puts
   end
      
end

p = PMain.new
p.help
p.prompt
   