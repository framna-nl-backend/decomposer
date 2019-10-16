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

Decomposer itself is written in bash, but there's a few other tools it uses:

* [jq](https://stedolan.github.io/jq/) - Needed for the parsing of the decomposer.json file
* [autoload-psr](https://github.com/pprkut/autoload-psr) - Used for autoloading of PHP libraries
* [git](https://git-scm.com/) - Only libraries from git repositories are supported
* md5sum or md5 command

Installation
===

## Local installation
add the `bin` directory to your PATH.

## System wide installation
run `make install`

Usage
===

Decomposer currently supports these commands:

  `decomposer validate`

  > Validate the decomposer.json file

  `decomposer install`

  > Install all the libraries

  `decomposer generate-changelog`

  > Generate a changelog of the main project and its libraries

You can get a more detailed description about them in the `doc` folder.
Or you can also run `decomposer help {command}` to display the manual of that command.

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

Then you can run all the tests with any of the following commands:

  `bats tests`
  `make test`

Test files must be located one level below the `tests` folder with a `.bats` extension.

Docs
===

To generate the man pages from the doc, you also need to have:

* [scdoc](https://git.sr.ht/~sircmpwn/scdoc) - Man page generator

Then you can generate the man pages with the following command:

  `make doc`
