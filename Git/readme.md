How to rebase a specific branch:
- git checkout master —rebase
- git checkout [your branch]
- git rebase master

If have any conflict
- git status
- git add [conflicted-file]
- git rebase —continue
- git status

Push code to git:
- git push --force origin [branch-name]


------
solve a messed and mixed branch:

Get a hashcode commit/branch which has been messed/deleted
- git reflog
Show all changed file in specfic
- git show [commit-hashcode]
Pick a specific commit to the top
- git cherry-pick [commit-hashcode]


------
Combine n commit to only one:
- git rebase -i HEAD~n
- a new editor window will show, keep only the first line, replace `pick` word to `s` (from line 2 to n)
- save and exit file
- another editor window will show, add new commit message in the top
- save and exit file
- git commit --amend -m "new message"
- git push --force origin [branch-name]
