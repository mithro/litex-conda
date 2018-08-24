#!/bin/bash

if ! which conda; then
	export PATH=~/conda/bin:$PATH
fi

# Disable this warning;
# xxxx/conda_build/environ.py:377: UserWarning: The environment variable
#     'TRAVIS' is being passed through with value 0.  If you are splitting
#     build and test phases with --no-test, please ensure that this value is
#     also set similarly at test time.
export  PYTHONWARNINGS=ignore::UserWarning:conda_build.environ

if [ -z "$DATESTR" ]; then
        if [ -z "$DATESHORT" ]; then
                export DATESTR=$(date -u +%Y%m%d%H%M%S)
                echo "Setting long date string of $DATESTR"
        else
                export DATESTR=$(date -u +%y%m%d%H%M)
                echo "Setting short date string of $DATESTR"
        fi
fi
if [ -z "$GITREV" ]; then
	export GITREV="$(git describe --long)"
	echo "Setting git revision $GITREV"
fi

export TRAVIS=0
export CI=0

export TRAVIS_EVENT_TYPE="local"
echo "TRAVIS_EVENT_TYPE='${TRAVIS_EVENT_TYPE}'"

export TRAVIS_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
echo "TRAVIS_BRANCH='${TRAVIS_BRANCH}'"

export TRAVIS_COMMIT="$(git rev-parse HEAD)"
echo "TRAVIS_COMMIT='${TRAVIS_COMMIT}'"

export TRAVIS_REPO_SLUG="$(git rev-parse --abbrev-ref --symbolic-full-name @{u})"
echo "TRAVIS_REPO_SLUG='${TRAVIS_REPO_SLUG}'"

./conda-meta-extra.sh
conda $@
