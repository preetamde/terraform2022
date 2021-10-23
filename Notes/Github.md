# Github basics

1. set the global config
2. how do you do this?

   > git config --global user.name

   > git config --global user.email

   ```
   # sets up Git with your name
   git config --global user.name "<Your-Full-Name>"
   
   # sets up Git with your email
   git config --global user.email "<your-email-address>"
   
   # makes sure that Git output is colored
   git config --global color.ui auto
   
   # displays the original state in a conflict
   git config --global merge.conflictstyle diff3
   
   git config --list

   git config --global core.editor "code --wait"

   ```

## Useful Git log commands

   Option   Description

-p             Show the patch introduced with each commit. !! Important

--stat         Show statistics for files modified in each commit. !! Important

--name-only    Show the list of files modified after the commit information. !! Important

--oneline         Shorthand for --pretty=oneline --abbrev-commit used together. !! Important

--shortstat    Display only the changed/insertions/deletions line from the --stat command.

--name-status  Show the list of files affected with added/modified/deleted information as well.

--abbrev-commit   Show only the first few characters of the SHA-1 checksum instead of all 40.

--relative-date   Display the date in a relative format (for example, “2 weeks ago”) instead of using the full date format.

--graph           Display an ASCII graph of the branch and merge history beside the log output.

--pretty          Show commits in an alternate format. Option values include oneline, short, full, fuller, and format (where you specify your own format).
