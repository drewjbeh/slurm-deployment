Role Overview
=========

The role `common` is responsible to perform two tasks:
- Update the repository
- Install the list of defined packages



Role Variables
--------------

There's only one variable that's defined in this role, which is 
`packages_to_install` (defaults/main.yml). A list containing the name of 
packages that should be installed.

The variable can be overriden, however, it is not recommended.

Example Playbook
----------------

Below is a simple playbook that shows how to use the role in order to
properly install and setup the vault.

    - name: Setup vault server
      hosts: vm-1
      become: true
      roles:
        - common

> It will take some time to perform the first `apt-update` when initially 
> running the role. Once it's done, everything runs fairly smoothly.


