
def app_root
  "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}#{env['SCRIPT_NAME']}"
end

#NOTE:実装上で注意する点
#   - リンクが入れ子になっている場合あり
#   eg.)  [![img](link_to_img)](link)
def fix_relative_links(mkd,url) 
    #@params
    #  String,String  : markdown,page_url
    #@return
    #  String : fixed markdown
    #NOTE:
    #  [alt](/path/to/link) -- (*) と [alt](../../(etc.etc...)/path/to/link) -- (**) の2種類を直す
    fix_link = lambda { |link_,url_| #アンダーバーはruby1.8対策
        unless link_.include?("://") or link_.match("^javascript")
            if link_[0] == "/"
                base_url = (%r!\w+?://[\w.]*/!.match url_)[0]
                return base_url[0..(base_url.size-2)] + link_
            elsif link_[0..1] == ".."
                #FIXME: remove relative parts
                return url_ + link_
            end
        else
            return link_
        end
    }

    regexp_links = /\[(.*?)\]\((.*?)\)/
    mkd.gsub(regexp_links) do |matched|
        "[#{$1}](#{fix_link[$2,url]})"
    end
end

#save real images and fix img links to relative and local-oriented ones.
#@params
#  String,String  : markdown string,imgdir_fullpath
#@return
#  String  : Fixed markdown
def save_images(mkd,path)
    regexp_img_links = /!\[(.*?)\]\((.*?)\)/
    img_dirname = File.basename(path)
    FileUtils.mkdir_p(path,{:mode => 0755})
    client = HTTPClient.new
    mkd.gsub!(regexp_img_links).with_index do |matched,i|
        #save image
        alttext = $1
        imgurl = $2
        $stdout.puts imgurl

        ext = File.extname(imgurl).match(/(.*?)(?:\?.*)?$/)[1]
        filename = ("%07\d" % i)+ext
        filename_fullpath = File.join(path,filename)
        begin
            data=client.get_content(imgurl)
        rescue
            next
        end
        File.open(filename_fullpath,"w"){|file| file.write(data)}

        #fix the link
        "![#{alttext}](#{File.join("./",img_dirname,filename)}"
    end
end



def commit_page(url,path,log,mkd)
    repos = Grit::Repo.new(Conf['git_repos_path'])
    raise StandardError "invalid path" if path.include? ".."

    mkd_fullpath = File.join(Conf['git_repos_path'],path+"."+Conf['fileext']) 
    imgdir_fullpath = File.join(Conf['git_repos_path'],path)

    mkd = fix_relative_links(mkd,url)
    mkd = save_images(mkd,imgdir_fullpath)

    File.open(mkd_fullpath,"w").write(mkd)
    Dir.chdir(repos.working_dir) do |path|
        repos.add(mkd_fullpath)
        Dir.glob(File.join(imgdir_fullpath,"*")).each{|img| repos.add(img)}
    end
    repos.commit_index(log)
end
