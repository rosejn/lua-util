require 'os'
require 'fs'
require 'paths'

-- Boolean predicate to determine if a path points to a valid file or directory.
function is_file(path)
    return paths.filep(path) or paths.dirp(path)
end


-- Assert that a file exists.
function assert_file(path, msg)
    if not is_file(path) then
        assert(false, msg)
    end
end


-- Check that a data directory exists, and create it if not.
function check_and_mkdir(dir)
  if not paths.filep(dir) then
    fs.mkdir(dir)
  end
end


-- Decompress a .tgz or .tar.gz file.
function decompress_tarball(path)
   os.execute('tar -xvzf ' .. path)
end


-- unzip a .zip file
function unzip(path)
   os.execute('unzip ' .. path)
end


-- gunzip a .gz file
function gunzip(path)
   os.execute('gunzip ' .. path)
end


-- Decompress tarballs and zip files, using the suffix to determine which
-- method to use.
function decompress_file(path)
    if string.find(path, ".zip") then
        unzip(path)
    elseif string.find(path, ".tar.gz") or string.find(path, ".tgz") then
        decompress_tarball(path)
    elseif string.find(path, ".gz") or string.find(path, ".gzip") then
        gunzip(path)
    else
        print("Don't know how to decompress file: ", path)
    end
end


-- Download the file at location url.
function download_file(url)
    local protocol, scpurl, filename = url:match('(.-)://(.*)/(.-)$')
    if protocol == 'scp' then
        os.execute(string.format('%s %s %s', 'scp', scpurl .. '/' .. filename, filename))
    else
        os.execute('wget ' .. url)
    end
end


-- Temporarily changes the current working directory to call fn, returning its
-- result.
function do_with_cwd(path, fn)
    local cur_dir = fs.cwd()
    fs.chdir(path)
    local res = fn()
    fs.chdir(cur_dir)
    return res
end


-- Check that a file exists at path, and if not downloads it from url.
function check_and_download_file(path, url)
  if not paths.filep(path) then
      do_with_cwd(paths.dirname(path), function() download_file(url) end)
  end

  return path
end

