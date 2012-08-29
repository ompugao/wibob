set :haml , :escape_html => true

before do
    puts '===Params==='
    pp params
    puts '============'
end

before '/*.json' do
  content_type 'application/json'
  headers "Access-Control-Allow-Origin" => "*"
end

get '/' do
  @title = Conf['title']
  haml :index
end

client = HTTPClient.new

post '/posturl.json' do
    mkd = PandocRuby.convert(client.get_content(params[:url]).force_encoding("UTF-8"),{:from => "html",:to=>"markdown"})
    JSON.pretty_generate({:markdown=>mkd,
          :html=>PandocRuby.convert(mkd,{:from => "markdown",:to=>:html},:mathml)})
end

post '/posttext.json' do
    mkd = params[:text].encode("UTF-8")
    JSON.pretty_generate({:markdown => mkd,
          :html=>PandocRuby.convert(mkd,{:from => "markdown",:to=>:html},:mathml)})
end

post '/save.json' do
    mkd = params[:text].encode("UTF-8")
    #TODO: save text to git repos
end

