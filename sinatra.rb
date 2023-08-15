require 'sinatra'
require 'sqlite3'
require 'date'

def sanitize(filename)
  # Remove any characters that aren't 0-9, A-Z, or a-z, or '.'
  filename.gsub(/[^0-9A-Z.]/i, '_')
end

get '/' do
  @content = ""
  now = DateTime.now
  @datenow = now.strftime("%Y-%m-%d")
  @timenow = now.strftime("%H:%M")
  erb :index
end

post '/' do
  STDERR.puts params.to_s
  @content = params[:content]
  @datenow = params[:date]
  @timenow = params[:time]
  if params.has_key?("pic")
    @filename = sanitize params[:pic][:filename]
    file = params[:pic][:tempfile]
    File.open("./public/img/#{@filename}", 'wb') do |f|
      f.write(file.read)
    end
    new_text = "![](/img/#{@filename} \"#{@filename}\")"
    @content = "#{@content}\n\n#{new_text}"
  end
  erb :index
end
	
get '/upload' do
  erb :upload
end

post '/upload' do
  STDERR.puts params.to_s
  @filename = params[:pic][:filename]
  file = params[:pic][:tempfile]

  File.open("./public/img/#{@filename}", 'wb') do |f|
    f.write(file.read)
  end
  
  new_text = "![](http://localhost:4567/#{@filename} \"#{@filename}\")" 
  erb :upload
end
