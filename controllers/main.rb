set :haml , :escape_html => true

before do
    $stderr.puts '===Params==='
    pp params
end

before '/*.json' do
  content_type 'application/json'
  headers "Access-Control-Allow-Origin" => "*"
end

get '/' do
  @title = Conf['title']
  haml :index
end

post '/posturl.json' do
    #encode the content of url to markdown
    orig_content = HTTPClient.new.get_content(params[:url])
    begin
        mkd = PandocRuby.convert(orig_content.encode("UTF-8"),{:from => "html",:to=>"markdown"})
    rescue => e
        $stderr.puts "EncodingError"
        mkd = PandocRuby.convert(orig_content.toutf8  ,{:from => "html",:to=>"markdown"}) # guess encoding
    end
    mkd = PandocRuby.convert(orig_content.force_encoding("UTF-8")  ,{:from => "html",:to=>"markdown"}) if mkd.empty? # force encoding

    JSON.pretty_generate({:markdown=>mkd,
          :html=>PandocRuby.convert(mkd,{:from => "markdown",:to=>:html},:mathml)})
          #:html=>PandocRuby.convert(mkd,{:from => "markdown",:to=>:html},:mathml).gsub!(/<script.*>([\w\W]+?)<\/script>/ , "")})
end

post '/posttext.json' do
    mkd = params[:text].encode("UTF-8")
    JSON.pretty_generate({:markdown => mkd,
          :html=>PandocRuby.convert(mkd,{:from => "markdown",:to=>:html},:mathml)})
end

post '/save.json' do
    commitpath = params[:commitpath]
    commitlog = params[:commitlog]
    url = params[:url]
    mkd = params[:text].encode("UTF-8")
    commit_page(url,commitpath,commitlog,mkd)
    #FIXME: have to return correct result.
    JSON.pretty_generate({:result => "done"})
end

