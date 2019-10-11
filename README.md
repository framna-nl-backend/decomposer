Decomposer
====
Library manager for PHP projects

Decomposer is a tool that helps you manage the libraries you use in your PHP projects. It takes care of installing and
updating dependencies as well as creating an include file that sets up your libraries for you so they are ready to use.
Contrary to other tools, libraries are installed in a globally shared location to facilitate sharing between projects.

Decomposer is *not* a dependency manager. There's no facilities for automatic dependency resolution or guessing of
which versions you need. Decomposer does not recursively traverse projects to install all libraries needed. Instead
all libraries that may be needed by your project need to be defined in your project, even if you don't use them
directly. This way you are always in full control of your software stack.

Requirements
===

Decomposer itself is just a bash script, but there's a few other tools it uses:

* [jq](https://stedolan.github.io/jq/) - Needed for the parsing of the decomposer.json file
* [autoload-psr](https://github.com/pprkut/autoload-psr) - Used for autoloading of PHP libraries
* [git](https://git-scm.com/) - Only libraries from git repositories are supported
* md5sum or md5 command

Installation
===

Clone the repository and add the `bin` directory to your PATH.

Usage
===

Decomposer currently supports these commands:

  `decomposer help`

  > Display help

  `decomposer install`

  > Installs all the libraries listed in `decomposer.json` and generates the include file.

The include file contains a check that returns an error in case it is outdated.
This extra check is mainly useful on a development environment to get warned to rerun `decomposer` after the
project's last pull of changes updated the `decomposer.json` file. It should not be necessary on a controlled
production environment. Not having it there is saving some unnecessary computing for every process.
On such a production environment, the `--no-dev` should be then used.

For the install command the `-c FILE / --changelog=FILE` option can be passed. This will create a file containing
the changes in the dependencies and in the main project (since last installation) in markdown format.
The optional FILE argument is used to specify the changelog file location. If no location is provided decomposer
falls back to a `decomposer.diffnotes.md` file in the current working directory.

Install location of libraries is controlled using the environment variable `TARGET_DIR`. By default this is
`/var/www/libs`.

As a precaution to not wreak havoc on your development setup, decomposer will not touch libraries in `TARGET_DIR`
that are manually installed using symbolic links or git worktree checkouts. However, do note that in case it is
a normal git clone, decomposer will reset the repo and throw away any local changes.

decomposer.json
===

```json
{
    "Lunr": {
        "url": "m2:/mmw/lunr.git",
        "version": "0.5",
        "revision": "master",
        "psr4": {
            "prefix": "Lunr",
            "search-path": "/src/Lunr/"
        }
    },
    "Requests": {
        "url": "https://github.com/rmccue/Requests.git",
        "version": "1.7.0",
        "psr0": {
            "path": "/library/"
        }
    },
    "Credis": {
        "url": "https://github.com/colinmollenhour/credis.git",
        "version": "1.7",
        "target-dir": "/Credis",
        "psr0": {
            "path": "/"
        }
    }
}
```

The content of `decomposer.json` is a JSON object, where the key is the name of the library and the value is another
JSON object holding the configuration. The following keys are supporting within configuration:

* url (required) - The git clone URL for the library
* version (required) - The version of the library (This should map a tag with either the same name or in the form of 'v{version}',
            unless revision is specified as well. In that case this is merely used as an identifier)
* revision (optional) - Can be used to install a specific branch/commit
* target-dir (optional) - Can be used to clone the library to a specific subdirectory in order to satisfy autoloading structure
* psr0 (optional) - Autoloader configuration using [PSR-0](https://www.php-fig.org/psr/psr-0/)
* psr4 (optional) - Autoloader configuration using [PSR-4](https://www.php-fig.org/psr/psr-4/)

Either the `psr0` or the `psr4` field should be present.

The `psr-0` configuration contains one setting `path`, that holds the relative path from the libraries repository root
where the PHP libraries are located.

The `psr-4` configuration contains `prefix`, which holds the namespace prefix to register with PSR-4, as well as
`search-path`, which holds the relative path from the libraries repository root where the PHP libraries are located.
The `psr-4` configuration can also be an array of such objects in case multiple prefixes or search paths are needed.

Tests
===

To run the tests, you also need to have:

* [bats-core](https://github.com/bats-core/bats-core) - Testing framework for Bash

Then you can run all the tests with the following command:

  `bats tests`

Test files must be located one level below the `tests` folder with a `.bats` extension.
