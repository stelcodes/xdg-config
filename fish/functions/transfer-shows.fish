function transfer-shows
  set --function paths
  set --function tmp $(mktemp)

  nnn -p $tmp || return 1

  if test ! -f $tmp
    echo "No directories selected"
    return 1
  end

  for path in $(cat $tmp)
    if test ! -d $path
      echo "$path is not a directory"
      return 1
    end
    set --append paths $(string replace --regex '/+$' '' $path)
  end

  rsync --archive --verbose --human-readable --progress --one-file-system --ignore-existing \
  $paths \
  macmini-1.local:/run/media/stel/wolf6-1/library/videos/shows/ \
  && trash $tmp $paths
end
