#!/bin/bash
set -e

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

# ensure a clone of all repositories exists
for dir in "${!repo_names[@]}"; do
    [[ -d ../$dir/.git ]] && continue
    echo "==> Cloning $dir"
    repo=${repo_names[$dir]:-$dir}
    git -C .. clone -c core.symlinks=true "git@github.com:Martchus/$repo.git" "$dir"
done

# ensure the fallback repo is added
for dir in "${!repo_names[@]}"; do
    repo=${repo_names[$dir]:-$dir}
    if ! git -C "../$dir" remote show gitea &> /dev/null ; then
        echo "==> Adding fallback remote for $dir"
        git -C "../$dir" remote add gitea "gitea@martchus.no-ip.biz:Martchus/$repo.git"
    fi
    if ! git -C "../$dir" remote show all &> /dev/null ; then
        echo "==> Configuring 'all' remote for $dir"
        git -C "../$dir" remote add all "git@github.com:Martchus/$repo.git"
        git -C "../$dir" remote set-url --add --push all "git@github.com:Martchus/$repo.git"
        git -C "../$dir" remote set-url --add --push all "gitea@martchus.no-ip.biz:Martchus/$repo.git"
    fi
done

# ensure all repositories are up-to-date
for dir in ../* ; do
    [[ -d $dir/.git ]] || continue
    echo "==> Updating $dir"
    git -C "$dir" remote update
    branch_name=$(git -C "$dir" symbolic-ref -q HEAD)
    branch_name=${branch_name##refs/heads/}
    branch_name=${branch_name:-DETACHED}

    # try pushing local changes first
    if git -C "$dir" push -u all master:master ; then
        git -C "$dir" remote update
    fi

    if output=$(git -C "$dir" status --porcelain) && [[ -z $output ]] && [[ $branch_name == DETACHED || $branch_name == master ]]; then
        git -C "$dir" reset --hard origin/master
    fi
done

