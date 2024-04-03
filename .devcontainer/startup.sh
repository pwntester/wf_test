# Install CodeQL CLI
gh extensions install github/gh-codeql

# Set CodeQL CLI version to latest
gh codeql set-version latest

# Install CodeQL CLI stub to the path specified in settings.json
gh codeql install-stub /home/codespace/.local/bin

# Download submodules (if any)
git submodule init && git submodule update --recursive

cd ../

# Download CodeQL databases
gh api /repos/${GITHUB_REPOSITORY}/code-scanning/codeql/databases --jq '.[].language' | while read LANG; do
    gh api -H "Accept: application/zip" /repos/${GITHUB_REPOSITORY}/code-scanning/codeql/databases/$LANG > database_$LANG.zip
    codeql database unbundle database_$LANG.zip --name=../database_$LANG
    rm database_$LANG.zip
done
