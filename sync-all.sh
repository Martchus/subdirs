#!/bin/bash
set -e
shopt -s nullglob

subdirs_path=$(dirname -- "$(realpath -- "$0")")
cd "$subdirs_path"

declare -A repo_names=(
    [c++utilities]=cpp-utilities
    [qtutilities]=
    [qtforkawesome]=
    [syncthingtray]=
    [tagparser]=
    [tageditor]=
    [passwordfile]=
    [passwordmanager]=
    [videodownloader]=
    [reflective-rapidjson]=
    [dbus-soundrecorder]=
    [geocoordinatecalculator]=
    [auto-makepkg]=arch-repo-manager
    [PianoBooster]=
    [subdirs]=
)

[[ $# -gt 0 ]] && relevant_dirs=("$@") || relevant_dirs=("${!repo_names[@]}")

# ensure a clone of all repositories exists
for dir in "${relevant_dirs[@]}"; do
    [[ -d ../$dir/.git ]] && continue
    echo "==> Cloning $dir"
    repo=${repo_names[$dir]:-$dir}
    git -C .. clone -c core.symlinks=true "git@github.com:Martchus/$repo.git" "$dir"
done

# ensure the fallback repo is added
for dir in "${relevant_dirs[@]}"; do
    [[ -d ../$dir/.git ]] && continue
    repo=${repo_names[$dir]:-$dir}
    if ! git -C "../$dir" remote show gitea &> /dev/null ; then
        echo "==> Adding fallback remote for $dir"
        git -C "../$dir" remote add gitea "gitea@martchus.dyn.f3l.de:Martchus/$repo.git"
    fi
    if ! git -C "../$dir" remote show all &> /dev/null ; then
        echo "==> Configuring 'all' remote for $dir"
        git -C "../$dir" remote add all "git@github.com:Martchus/$repo.git"
        git -C "../$dir" remote set-url --add --push all "git@github.com:Martchus/$repo.git"
        git -C "../$dir" remote set-url --add --push all "gitea@martchus.dyn.f3l.de:Martchus/$repo.git"
    fi
done

# ensure all repositories are up-to-date
[[ $# -gt 0 ]] && relevant_dirs=("${relevant_dirs[@]/#/../}") || relevant_dirs=(../*)
for dir in "${relevant_dirs[@]}"; do
    [[ -d $dir/.git ]] || continue
    echo "==> Updating $dir"
    git -C "$dir" remote update
    branch_name=$(git -C "$dir" symbolic-ref -q HEAD) || true
    branch_name=${branch_name##refs/heads/}
    branch_name=${branch_name:-DETACHED}
    echo "current branch: $branch_name"

    # try pushing local changes first
    if git -C "$dir" push -u all master:master ; then
        git -C "$dir" remote update
    else
        echo "Unable to push local changes of '$dir' to master, trying to rebase anyway."
    fi

    # clean files like "git-config.exe.stackdump"
    files_to_delete=("$dir"/*.stackdump)
    if [[ ${#files_to_delete[@]} -gt 0 ]]; then
        echo "Deleting junk files within '$dir':"
        rm -v "${files_to_delete[@]}"
    fi

    # clean changes to global.h
    git -C "$dir" restore '*global.h' || true

    # reset to current master
    if [[ $branch_name != DETACHED && $branch_name != master ]]; then
        echo "Not touching '$dir' - it isn't on master or a detached had (it is on $branch_name)."
        continue
    fi
    if output=$(git -C "$dir" status --porcelain) && [[ -z $output ]]; then
        git -C "$dir" reset --hard origin/master
    else
        echo "Not touching '$dir' - it isn't clean:\n$output"
    fi
done

