require 'sinatra'

def sanitize(filename)
  # Remove any character that aren't 0-9, A-Z, or a-z, or '.'
  filename.gsub(/[^0-9A-Z.]/i, '_')
end

get '/' do
  @content = ""
  erb :index
end

post '/' do
##  STDERR.puts params.to_s
  @content = params[:content]
  @filename = sanitize params[:pic][:filename]
  file = params[:pic][:tempfile]
  File.open("./public/img/#{@filename}", 'wb') do |f|
    f.write(file.read)
  end
  new_text = "![](/img/#{@filename} \"#{@filename}\")"
  @content = "#{@content}\n\n#{new_text}"
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
