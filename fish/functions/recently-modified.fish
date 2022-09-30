function recently-modified
  find  -L "$argv[1]" -not -name "*/.cache*" -type f -mount -printf "%T+ %p\n" 2> /dev/null | sort
end
