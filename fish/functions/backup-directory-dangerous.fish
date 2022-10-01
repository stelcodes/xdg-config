function backup-directory-dangerous
    read --function --prompt-str "source directory: " --shell source_dir
    if test ! -d $source_dir
      echo "source is not a directory"
      echo "aborting backup duplication"
      return 1
    end
    set --function source_dir $(readlink -f $source_dir)

    read --function --prompt-str "overwrite directory: " --shell overwrite_dir
    if test ! -d $overwrite_dir && test -e $overwrite_dir
      echo "overwrite directory must be an existing directory or nonexistent"
      echo "aborting backup duplication"
      return 1
    end
    set --function overwrite_dir $(readlink -f $overwrite_dir)
    if test -d $overwrite_dir
      echo -e "\n$overwrite_dir exists and has these contents:"
      echo -e "$(ls -lahA $overwrite_dir | head)\n"
      read --function --prompt-str "do you really want to overwrite $overwrite_dir [y/n]: " confirm_overwrite
      if test $confirm_overwrite != "y"
        echo "aborting backup duplication"
        return 1
      end
    else
      echo "overwrite directory does not exist and will be created"
    end

    set --function rsync_command "rsync --archive --verbose --human-readable --progress --one-file-system --delete $source_dir/ $overwrite_dir"

    echo -e "\n$rsync_command\n"
    read --function --prompt-str "does this command look good [y/n]: " confirm_command
    if test "$confirm_command" != "y"
      echo "aborting backup duplication"
      return 1
    end

    eval "$rsync_command"
end
