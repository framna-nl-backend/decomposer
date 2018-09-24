TODO
===

`target-dir` field rethinking
---

There is currently some issues with the usage of the `target-dir` field.

This field was initially added to be able to have PSR-0 autoloading of
libraries such as [Credis](https://github.com/colinmollenhour/credis), which
can be conformed to the PSR-0 standard only if the repository is cloned as
`Credis` in order to simulate the namespace.  
That is because the repository doesn't contain itself this folder and classes
are available directly in the root folder with names such as `Credis_Client` in
a file called `Client.php`. Thus `Credis_Client` can be autoloaded if the
`Client.php` file is within a `Credis` folder, itself within the PHP include
path.

The problem is a conflict with the `psr-0` object `path` field.  
If the `path` is not defined to be `/` then the library autoloading file would
try to include a non-existing folder.

Also the `target-dir` should be useless for libraries using PSR-4 autoloading
since a prefix can be defined there. Thus it might be better to restrict its
usage only to libraries using PSR-0.
