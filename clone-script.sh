 repositoryNameA=("" "" "" "" "" "")
 for ((i=0; i<${#repositoryNameA[@]}; i++)); do
     repository="${repositoryNameA[$i]}"
     rm -rf ~/repos/"$repository"
     mkdir -p ~/repos/"$repository"
     cd ~/repos || exit
     git clone "https://$(gitlab-patname):$(gitlab-pat)@{url}/{group-name}/$repository"
     cd "$repository" || exit
     git fetch --all
     for branch in `git branch -r | grep -v 'HEAD\|origin/HEAD'`; do
         branch_name=${branch#origin/}
         git checkout -b "$branch_name" "origin/$branch_name"
     done

     git remote add azure "https://$(devops-patname):$(devops-pat)@dev.azure.com/{org-name}/{project-name}/_git/$repository"
     git push --force --all azure
     git push --tags azure
 done
