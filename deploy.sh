#!/bin/bash

set -o errexit

# Sanity check: No pull requests and ensure we're on the master branch
if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
    echo "Won't attempt to build on pull requests. Exiting."
    exit 0
fi

if [ "$TRAVIS_BRANCH" != "master" ]; then
    echo "The requested branch is not master. Exiting."
    exit 0
fi

sudo npm install
# Generate the resume as pdf, png and yml
npm run generate-pdf
# Generate the resume as html
npm run generate-site

rm -rf out
mkdir out
cd out
cp ../resume.* .
cp ../index.html .

# Deploy
git config --global user.name "Travis-CI"
git config --global user.email "travis-ci@travis-ci.org"

git init
git add .
git commit -m "Deployed resume to github pages branch through travis-ci."
git push --force --quiet "https://${GITHUB_TOKEN}@${GH_REF}" master:gh-pages > /dev/null 2>&1

echo "Resume deployed successfully"
exit 0
