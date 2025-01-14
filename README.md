# CFPB Mac setup scripts

Configurations and scripts for setting up a new developer Mac.


## Automated software setup

The `provision_tools.sh` script installs a standard developer environment
on new Mac computers, with the goal of making the machine ready to set up
[cfgov-refresh](https://github.com/cfpb/cfgov-refresh) for local development.
This includes, but is not limited to:

- [Homebrew](http://brew.sh/)
- Up-to-date or cfgov-refresh-specific versions of several core developer tools:
  - Git (replacing Apple Git)
  - pyenv and pyenv-virtualenvwrapper, with:
    - Python 3 (as `python`)
    - Python 2 (as `python2`)
  - PostgreSQL
  - nvm with the latest LTS release of Node
  - Yarn with the following installed globally:
    - yo
    - generator-cf
    - generator-node
    - snyk
- [git-secrets](https://github.com/awslabs/git-secrets) hooks
  for ensuring you don't accidentally commit bad stuff
- Minimal dotfiles with the necessary bits for all of the above to work as expected

### Running the script

1. Run the following command from the root of this repository
   to initiate the installation: `./provision_tools.sh`.
1. After the script completes, run `source ~/.bashrc`
   to apply the changes to your current terminal session,
   or just close the session and open a new one.

### Backups

- If any dotfiles (`~/.bash_profile`, `~/.bashrc`, etc.) would be overwritten,
  they will be backed up to `~/<filename>_<date>`.
- If you have anything in your `~/.git-templates/` folder and
  your global `.gitconfig` has `init.templateDir` value is set to that location,
  your files will be left in place
  and the `init.templateDir` will be changed to `~/.git-templates/git-secrets/`.


## GitHub/SSH setup

The `github_setup.sh` script has two functions:

1. Ensure the `~/.gitconfig` file in your home directory has a name and
   email address configured so that you get credit for your commits.
1. Create an SSH key (if it doesn't already exist) for integration with
   GitHub.com and CFPB's GitHub Enterprise instance.
   - If generating an SSH key, you will be prompted
     to create a password for the key.

After the script completes, you will be provided with a "public key"
and the following instructions for applying the key to your two GitHub accounts:

1. Log into your GitHub accounts and paste this public key in the GitHub Settings website
1. [Directions for adding keys](https://help.github.com/en/articles/adding-a-new-ssh-key-to-your-github-account)

The script is safe to run even if you have already
configured your `.gitconfig` and/or SSH key.
In this case, the tool will simply output your existing details for your review.

### Running the script

Run the following command from the root of this repository: `./github_setup.sh`.


### Automated github_setup.sh execution at login

This section is intended for CFPB Mac Engineering's automation of
the `github_setup.sh` script on new Macs.

1. Place the file `github_setup.sh` at the location
   `/usr/local/bin/github_setup.sh`.
   - Make sure the file is world executable:
   `chmod +x /usr/local/bin/github_setup.sh`.
1. Place the file `org.cfpb.github_setup.plist` at the location
   `/Users/<username>/Library/LaunchAgents/org.cfpb.github_setup.plist`
   for the user(s) on the computer.
   - This will spawn the `github_setup.sh` script when the user logs on.
   - Once the user has completed the process, the plist will be disabled
     to stop future login execution.
