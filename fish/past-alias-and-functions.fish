# cd places
alias de="cd ~/Desktop"
alias dm="cd ~/temp"
alias dt="cd ~/data"
alias dwi="cd ~/data/wiki"
alias d.="cd ~/.scripts"
alias db="cd ~/bin"
alias dw="cd ~/Downloads"
# rust
# alias rbnowarning="RUSTFLAGS="-A warnings" cargo build"
# run code fast
alias :ts="fish -c 'cd ~/src/ts; bun run try'"
# other
# alias :id="pnpm add -d" # dev dep install
alias sf="source ~/.config/fish/config.fish" # source fish config
alias wgi="watchexec --restart --exts go \"tput reset && go install .\""
alias wg="watchexec --restart --exts go \"tput reset && go run .\""
# alias dw="deno task watch"
alias :d="bun dev"
alias :t="bun test --watch"
alias e="edgedb"
alias :s="cd ~/src/ts/packages/solid && bun dev" # run solid web server
alias :j="cd ~/src/ts && bun dev"
# alias :r="cd ~/src/rust && bun dev"
alias :t="cd ~/src/python && bun dev"
alias getLastCommitHash="git log -1 --format=\"%H\""
# alias pr="pnpm run"
# alias pw='pnpm add -w'
alias gmt='go mod tidy'
alias findAll.gitInCurrentDir="find . -type d -name .git"
alias nv="sudo nvim"
alias o="ollama"
alias z="zig"
alias python="python3"
alias s="swift"
alias dr="cd ~/private"

# from https://gist.github.com/nikoheikkila/dd4357a178c8679411566ba2ca280fcc
function envsource
    for line in (cat $argv | grep -v '^#' | grep -v '^\s*$')
        set item (string split -m 1 '=' $line)
        set -gx $item[1] $item[2]
        echo "Exported key $item[1]"
    end
end

function o
    ls | ollama run llama3.1:8b
    # ls | ask "$argv"
end

function oo
    ollama run llama3:8b-text-fp16 "$argv"
    # ask "$argv"
end

# TODO: breaks down, move to https://github.com/sobelio/llm-chain or update the code
function os
    set max_attempts 3
    set attempt 1
    set command_failed true
    set output ""
    set error_output ""

    while test $attempt -le $max_attempts
        set command (ollama run llama3:8b-instruct-q5_K_M "return with the command I can enter in my terminal for this task: $argv. Just the command, so it runs. If you are uncertain, reply `false`")

        if test "$command" = false
            if test $attempt -eq $max_attempts
                echo "Command could not be determined."
            end
            return 1
        end

        # Attempt to run the command, capturing stdout and stderr
        set output (eval $command 2>&1 | tee /dev/stderr)

        # Check if the command was successful
        if test $status -eq 0
            set command_failed false
            echo $output
            break
        else
            set error_output $output
            set attempt (math $attempt + 1)
        end
    end

    if test $command_failed = true
        echo $error_output
        echo "Failed to execute command after $max_attempts attempts."
    end
end

function la
    command la # overwrite `la` fish builtin function
end

# w - open current path in VSCode
# w <path> - open path in VSCode
#function w
#    if not set -q argv[1]
#        code-insiders .
#    else
#        code-insiders $argv
#    end
#end

# function generate_completions_for_colon_function
#     for script in (jq -r '.scripts | keys[]' package.json)
#         complete -c : -a "$script"
#     end
# end
# generate_completions_for_colon_function

# autocomplete from `package.json scripts` as you type with fzf matching
function ::
    set selected_script (jq -r '.scripts | to_entries | .[] | .key + " " + .value' package.json | fzf | awk '{print $1}')
    if test -n "$selected_script"
        bun run $selected_script
    end
end

bind \cg ::

function copyfile
    cat $argv | pbcopy
end

# function W
#     if not set -q argv[1]
#         zed .
#     else
#         zed $argv
#     end
# end

# function w
#     if not set -q argv[1]
#         cursor .
#     else
#         cursor $argv
#     end
# end

# function W
#     if not set -q argv[1]
#         cursor .
#     else
#         cursor $argv
#     end
# end

function we
    if not set -q argv[1]
        zed .
    else
        zed $argv
    end
end

# TODO: pass arg for extension, and also the command to rerun
# for now `js` is hardcoded
#function W
#    watchexec --no-vcs-ignore --restart --exts js "tput reset && $argv" --project-origin .
#end

function :w
    if not set -q argv[1]
        # TODO: replace with own wrapper that will watch for any `.ts` file in current dir (recursive). if file found, run it with `bun --watch <file-path>`
        bun --watch
    else
        bun --watch $argv
    end
end

# function wb
#     watchexec --no-vcs-ignore --restart --exts ts "tput reset && bun run $argv" --project-origin .
# end

# function runSwiftAndLogErrorsInFile
#     # Ensure the log file exists and is empty
#     echo -n "" > ~/log/cmd.log

#     # Run the command, display output, and append to log file
#     watchexec --no-vcs-ignore --restart --exts swift "tput reset && swift run.swift" --project-origin . 2>&1 | \
#     while read -l line
#         echo $line
#         echo $line | sed -E "s/\x1B\[([0-9]{1,3}(;[0-9]{1,3})*)?[mGK]//g" >> ~/log/cmd.log
#     end
# end

# function runSwiftAndLogErrorsInFile
#     # Ensure the log file exists and is empty
#     echo -n "" > ~/log/cmd.log

#     # Run the command, display output, and append to log file
#     watchexec --no-vcs-ignore --restart --exts swift "tput reset && swift run.swift" --project-origin . 2>&1 | \
#     while read -l line
#         # Display the line to the console
#         echo $line

#         # Remove ANSI escape codes and [Running: ...] lines before logging
#         echo $line | \
#         sed -E 's/\x1B\[[0-9;]*[mGK]//g' | \
#         sed -E 's/\[Running: .*\]//g' | \
#         sed -E '/^\s*$/d' >> ~/log/cmd.log
#     end
# end

# function runSwiftAndLogErrorsInFile
#     # Ensure the log file exists and is empty
#     echo -n "" > ~/log/cmd.log

#     # Run the command, display output, and append to log file
#     watchexec --no-vcs-ignore --restart --exts swift "tput reset && swift run.swift" --project-origin . 2>&1 | \
#     while read -l line
#         # Display the line to the console
#         echo $line

#         # Clean up and log the output using awk
#         echo $line | \
#         awk '
#         BEGIN { skip = 1 }
#         /^[[:space:]]*$/ { next }  # Skip empty lines
#         /^\[?[0-9]+ qc\[!p\[?[0-9;]*l?/ { sub(/^\[?[0-9]+ qc\[!p\[?[0-9;]*l?>/, ""); skip = 0 }
#         /^<unknown>:0: warning:/ || /^run\.swift:/ { skip = 0 }
#         !skip { gsub(/\x1B\[[0-9;]*[mK]/, ""); print }
#         ' >> ~/log/cmd.log
#     end
# end

# clean output but losing things
# function runSwiftAndLogErrorsInFile
#     # Ensure the log file exists and is empty
#     echo -n "" > ~/log/cmd.log

#     # Run the command, display output, and append to log file
#     watchexec --no-vcs-ignore --restart --exts swift "tput reset && swift run.swift" --project-origin . 2>&1 | \
#     while read -l line
#         # Display the line to the console
#         echo $line

#         # Clean up and log the output using awk
#         echo $line | \
#         awk '
#         BEGIN { skip = 1; buffer = "" }
#         /^\[?[0-9]+ qc\[!p\[?[0-9;]*l?/ { sub(/^\[?[0-9]+ qc\[!p\[?[0-9;]*l?>/, ""); skip = 0 }
#         /^<unknown>:0: warning:/ || /^run\.swift:/ { skip = 0 }
#         !skip {
#             gsub(/\x1B\[[0-9;]*[mK]/, "")
#             if ($0 ~ /^run\.swift:/) {
#                 if (buffer != "") print buffer
#                 buffer = $0
#             } else if ($0 ~ /^\[Command exited with/) {
#                 print buffer
#                 print $0
#                 buffer = ""
#             } else {
#                 buffer = buffer "\n" $0
#             }
#         }
#         END { if (buffer != "") print buffer }
#         ' >> ~/log/cmd.log
#     end
# end

# function runSwiftAndLogErrorsInFile
#     # Wipe the log file at the start of each run
#     echo -n "" > ~/log/cmd.log

#     # Run the command, display output, and process for logging
#     watchexec --no-vcs-ignore --restart --exts swift "tput reset && swift run.swift" --project-origin . 2>&1 | \
#     awk '
#     BEGIN { skip = 1; buffer = "" }
#     /^\[?[0-9]+ qc\[!p\[?[0-9;]*l?/ { sub(/^\[?[0-9]+ qc\[!p\[?[0-9;]*l?>/, ""); skip = 0 }
#     /^<unknown>:0: warning:/ || /^run\.swift:/ { skip = 0 }
#     {
#         # Always print to console
#         print $0
#     }
#     !skip {
#         gsub(/\x1B\[[0-9;]*[mK]/, "")
#         if ($0 ~ /^run\.swift:/) {
#             if (buffer != "") print buffer >> "'"$HOME"'/log/cmd.log"
#             buffer = $0
#         } else if ($0 ~ /^\[Command exited with/) {
#             print buffer >> "'"$HOME"'/log/cmd.log"
#             print $0 >> "'"$HOME"'/log/cmd.log"
#             buffer = ""
#         } else {
#             buffer = buffer "\n" $0
#         }
#     }
#     END { if (buffer != "") print buffer >> "'"$HOME"'/log/cmd.log" }
#     '
# end

# function runSwiftAndLogErrorsInFile
#     # Run the command and log output
#     watchexec --no-vcs-ignore --restart --exts swift "tput reset && swift run.swift" --project-origin . 2>&1 | tee ~/log/cmd.log

#     # Extract the last error block and copy to clipboard
#     awk '/^run\.swift:/ {buf=""; flag=1} flag {buf = buf $0 "\n"} /\[Command exited with 1\]/ {last=buf} END {printf "%s", last}' ~/log/cmd.log | pbcopy

#     echo "Last error block copied to clipboard."
# end

# swift watch
function sw
    # Wipe the log file at the start of each run
    echo -n "" > ~/log/cmd.log

    # Run the command, display output, and process for logging
    watchexec --no-vcs-ignore --restart --exts swift "tput reset && swift run.swift" --project-origin . 2>&1 | \
    awk '
    BEGIN { skip = 1; buffer = "" }
    /^\[?[0-9]+ qc\[!p\[?[0-9;]*l?/ { sub(/^\[?[0-9]+ qc\[!p\[?[0-9;]*l?>/, ""); skip = 0 }
    /^<unknown>:0: warning:/ || /^run\.swift:/ { skip = 0 }
    {
        # Always print to console
        print $0
    }
    !skip {
        gsub(/\x1B\[[0-9;]*[mK]/, "")
        if ($0 ~ /^run\.swift:/) {
            if (buffer != "") print buffer >> "'"$HOME"'/log/cmd.log"
            buffer = $0
        } else if ($0 ~ /^\[Command exited with/) {
            print buffer >> "'"$HOME"'/log/cmd.log"
            print $0 >> "'"$HOME"'/log/cmd.log"
            buffer = ""
        } else {
            buffer = buffer "\n" $0
        }
    }
    END { if (buffer != "") print buffer >> "'"$HOME"'/log/cmd.log" }
    '

    # Extract the last error block and copy to clipboard
    awk '/^run\.swift:/ {buf=""; flag=1} flag {buf = buf $0 "\n"} /\[Command exited with 1\]/ {last=buf} END {printf "%s", last}' ~/log/cmd.log | pbcopy

    echo "Last error block copied to clipboard."
end

function extractLastErrorBlockAndCopyToClipboard
    awk '
        /^run\.swift:/ {buf=""; flag=1}
        flag && !/\[Command exited with/ {
            gsub(/\x1B\[[0-9;]*[mGK]/, "")  # Remove ANSI color codes
            gsub(/^\[0m|\[31m/, "")         # Remove specific color codes
            buf = buf $0 "\n"
        }
        /\[Command exited with 1\]/ {
            last = buf
        }
        END {printf "%s", last}
    ' ~/log/cmd.log | sed '/^$/d' | pbcopy
end

# TODO:
function runSwiftAndLogErrorsInFileAndSaveErrorToClipboard
end

function wbi
    watchexec --no-vcs-ignore --restart --exts ts "tput reset && bun run index.ts" --project-origin .
end

function wbk
    watchexec --no-vcs-ignore --restart --exts ts "tput reset && bun run ../bin/$argv" --project-origin .
end

function wt
    watchexec --no-vcs-ignore --restart --exts ts "tput reset && tsx $argv" --project-origin .
end

function wd
    watchexec --no-vcs-ignore --restart --exts ts "tput reset && deno run $argv" --project-origin .
end

# function wn
#     watchexec --restart --exts ts "tput reset && node $argv" --project-origin .
# end

function wn
    watchexec --no-vcs-ignore --restart --exts ts "tput reset && tsx $argv" --project-origin .
end

function wg
    watchexec --no-vcs-ignore --restart --exts go "tput reset && go run $argv" --project-origin .
end

function gg
    if not set -q argv[1]
        go mod tidy
    else
        go get -u $argv
    end
end

function g
    if not set -q argv[1]
        watchexec --no-vcs-ignore --restart --exts go "tput reset && go run ."
    else
        go $argv
    end
end

function G
    if not set -q argv[1]
        watchexec --no-vcs-ignore --restart --exts go "tput reset && go test"
    else
        watchexec --no-vcs-ignore --restart --exts go "tput reset && go test -run $argv"
    end
end

# rb - put rust binary into PATH in debug
function rb
    set current_folder (basename (pwd))
    cargo build
    if test $status -eq 0
        mv target/debug/$current_folder ~/src/config/bin
    end
end

# R <cmd> - cargo <cmd>
function R
    cargo $argv
end

# TODO: it skips doing doc-tests, have another function for it?
# rt - `cargo test` on rust file changes
function rt
    if not set -q argv[1]
        cargo watch -q -- sh -c "tput reset && cargo test -q --lib"
    else
        # cargo $argv
    end
end

# forceRemoteGitBranchToBeThisCommit <commit-hash>:<branch-name>
function forceRemoteGitBranchToBeThisCommit
    set commit_hash (string split ":" $argv)[1]m i
    set branch_name (string split ":" $argv)[2]
    git push origin $commit_hash:$branch_name --force
end

# # p - pnpm i
# # p <dep> - pnpm i <dep>
# function p
#     if not set -q argv[1]
#         pnpm i
#     else
#         pnpm i $argv
#     end
# end

# p - pip3
# p <dep> - pip3 install <dep>
# function p
#     if not set -q argv[1]
#         pip3
#     else
#         poetry run python $argv
#         watchexec --no-vcs-ignore --restart --exts swift "tput reset && swift run.swift" --project-origin . 2>&1 | tee ~/log/cmd.log
#     end
# end

function p
    if test (count $argv) -eq 0
        echo "Usage: pw <python_script.py>"
        return 1
    end

    set script_name $argv[1]
    set log_file ~/log/cmd.log

    echo "" > $log_file  # Clear the log file

    watchexec --no-vcs-ignore --restart --exts py \
        "tput reset && poetry run python $script_name $argv[2..-1]" \
        --project-origin . 2>&1 | tee $log_file
end

function pi
    if not set -q argv[1]
        pip3
    else
        pip3 install $argv
    end
end

# R <flags or things to pass to CLI>
function R
    cargo watch -q -x "run -q -- $argv"
end

function gitCheckoutRemote
    git fetch origin
    git checkout -b $argv[1] origin/$argv[1]
end

# gi - go get package
# `go get -u github.com/spf13/cobra@latest
# function gi
#     go get -u github.com/leaanthony/clir@latest
# end

# envsource - source .env files (https://gist.github.com/nikoheikkila/dd4357a178c8679411566ba2ca280fcc)
function envsource
    for line in (cat $argv | grep -v '^#')
        set item (string split -m 1 '=' $line)
        set -gx $item[1] $item[2]
        echo "Exported key $item[1]"
    end
end

# :i = bun i
# :i <package> = bun add <package>
# function :i
#     if not set -q argv[1]
#         bun i
#     else
#         bun add $argv
#     end
# end

# pw <package.json command> - rerun command if .ts files change
# function pw
#     watchexec --no-vcs-ignore --restart --exts ts "tput reset && pnpm --silent run $argv" --project-origin .
# end

function goGetLatestPackage
    go get -u $argv@latest
end

function ios
    yarn ios
end

function iosCleanBuild
    expo prebuild --clean --ios
end

function .
    if not set -q argv[1]
        open .
    else
        # copy output to clipboard
        set -l output (eval $argv)
        echo $output | pbcopy
    end
end

# TODO:
# function :r
#     if not set -q argv[1]
#         # TODO: list all packages installed with bunx with fzf (top result is most recently ran bunx <package>)
#     else
#         bunx $argv
#     end
# end


function deleteGitLocalAndRemoteBranch
    set -l branch_name $argv[1]

    if test -z "$branch_name"
        echo "Please provide a branch name."
        return 1
    end

    # Delete local branch
    git branch -D $branch_name
    echo "Deleted local branch: $branch_name"

    # Delete remote branch
    git push origin --delete $branch_name
    echo "Deleted remote branch: $branch_name"
end

# TODO: not sure how useful
# function runPrettierOnAllGitFiles
#     git ls-files | grep -E '\.(js|css|html|ts|tsx)$' | xargs prettier --write
# end

function findFolder
    find . -type d -name $argv[1] -prune
end

function revertLastCommitAndPushForce
    git reset --hard HEAD~1
    git push origin HEAD --force
end

function killPort
    lsof -ti:$argv | xargs kill
end

function gitRemoteAddOriginWhileRemovingOldOne
    if test (count $argv) -lt 1
        echo "Usage: gitRemoteAddOriginWhileRemovingOldOne <new-origin-url>"
        return 1
    end

    set -l new_origin_url $argv[1]

    # Check if the 'origin' remote exists
    if git remote show | grep -q "^origin\$"
        # Remove the existing 'origin' remote
        git remote remove origin
    end

    # Add the new 'origin' remote
    git remote add origin $new_origin_url
    echo "Remote 'origin' set to $new_origin_url"
end

function fileToClipboard
    osascript \
        -e 'on run args' \
        -e 'set the clipboard to POSIX file (first item of args)' \
        -e end \
        $argv
end

# TODO: fix https://github.com/chand1012/git2gpt/issues/7
function turnCurrentFolderIntoZipForGpt
    git ls-files | zip ~/do/repo.zip -@; and fileToClipboard ~/do/repo.zip
    # rm -rf ~/do/repo.zip
end

# run rust with watch, log output/errors to log file
function :r
    env CARGO_TERM_COLOR=always cargo watch -q -- sh -c "tput reset && cargo run -q" 2>&1 | tee ~/log/cmd.log
end

function deleteAllGitFoldersRecursivelyExceptRootOne
    find . -type d -name ".git" -not -path "./.git" -exec rm -rf {} +
end

function :u
    bun update --latest
end

function :b
    bun web
end

function find.GitFolders
    for git_folder in (find . -type d -name ".git" -print)
        echo "Git repository found: $git_folder"
        echo "Remote URLs:"
        git --git-dir=$git_folder remote -v
        echo "Current branch:"
        git --git-dir=$git_folder --work-tree=(dirname $git_folder) branch --show-current
        echo ""
    end
end

function printFilesOneLevelDeep
    find . -maxdepth 2 -not -path '*/.*' -print0 | xargs -0 ls -ld
end

function gitAll
    # fetch all history
    git fetch --unshallow
    # fetch all branches
    git fetch --all
    # fetch all tags
    git fetch --tags
    # upadate local branches
    git pull --all
end

function checkGitRepoIsUsingSsh
    git remote -v | grep -q 'git@\|ssh://' && echo "Using SSH" || echo "Not using SSH"
end

function fixGitRemote
       # Get the current remote URL
       set current_url (git remote get-url origin)

       # Check if the URL is already in the correct SSH format
       if string match -q 'git@github.com:*' $current_url
           echo "Remote URL is already in the correct SSH format: $current_url"
       else
           # Extract the username and repo name
           set repo_info (string match -r 'github\.com[:/](.+)/(.+)(?:\.git)?' $current_url)
           set username $repo_info[2]
           set repo_name $repo_info[3]

           if test -n "$username" -a -n "$repo_name"
               # Construct the new SSH URL
               set new_url "git@github.com:$username/$repo_name.git"

               # Update the remote URL
               git remote set-url origin $new_url
               echo "Remote URL updated to: $new_url"
           else
               echo "Unable to parse the current URL. Please manually set the correct SSH URL."
               echo "Use: git remote set-url origin git@github.com:username/repo.git"
           end
       end
   end

function fixGitRemoteUrl
    # Check if we're in a Git repository
    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "Error: Not in a Git repository. Please run this command from within a Git repository."
        return 1
    end

    # Get the current remote URL
    set current_url (git remote get-url origin 2>/dev/null)
    if test $status -ne 0
        echo "Error: No remote named 'origin' found in this repository."
        return 1
    end

    # Extract the username and repository name
    set repo_info (echo $current_url | sed -E 's/.*github\.com[:/]([^/]+)\/([^/.]+)(\.git)?/\1 \2/')
    set username (echo $repo_info | cut -d ' ' -f 1)
    set repo_name (echo $repo_info | cut -d ' ' -f 2)

    # Construct the new SSH URL
    set new_url "git@github.com:$username/$repo_name.git"

    # Update the remote URL
    git remote set-url origin $new_url
    echo "Remote URL updated to use SSH: $new_url"

    # Verify the changes
    echo "Current remote URL:"
    git remote -v
end

# `git remote set-url origin git@github.com:learn-anything/learn-anything.xyz.git`
function gitSetUrlOrigin
    if test (count $argv) -lt 1
        echo "Usage: gitSetUrlOrigin <new-origin-url>"
        return 1
    end

    set -l new_origin_url $argv[1]

    # Check if the 'origin' remote exists
    if git remote show | grep -q "^origin\$"
        # Remove the existing 'origin' remote
        git remote remove origin
        echo "Removed existing 'origin' remote"
    end

    # Add the new 'origin' remote
    git remote add origin $new_origin_url
    echo "Added new 'origin' remote: $new_origin_url"

    # Verify the changes
    echo "Current remotes:"
    git remote -v
end


function lt
    if test (count $argv) -eq 1 && string match -qr '^[0-9]+$' -- $argv[1]
        # If exactly one argument is provided and it's a number, use it as a port
        command lt --port $argv[1] | tee /dev/tty | pbcopy
    else
        # Otherwise, pass all arguments to lt command as-is
        command lt $argv | tee /dev/tty | pbcopy
    end
end

# TODO: attempt at also copying result url into clipboard
# function lt
#     if test (count $argv) -eq 1 && string match -qr '^[0-9]+$' -- $argv[1]
#         # If exactly one argument is provided and it's a number, use it as a port
#         set output (command lt --port $argv[1])
#     else
#         # Otherwise, pass all arguments to lt command as-is
#         set output (command lt $argv)
#     end
#     # Display the output and copy to clipboard
#     echo $output | tee /dev/tty | pbcopy
# end

# function timeIt
#     set -l start_time (date +%s%N)
#     source $argv[1]
#     set -l end_time (date +%s%N)
#     set -l duration (math "($end_time - $start_time) / 1000000")
#     echo "Sourcing $argv[1] took $duration ms"
# end


# TODO: have to modify for each project, for now made to work with https://github.com/pqrs-org/osx-hid-inspector
# also header files
# function cpp
#     if test -z "$argv[1]"
#         watchexec --no-vcs-ignore --restart --exts cpp --clear --project-origin . "tput reset && make && src/build/Release/hid-inspector"
#         return 1
#     end
# end
