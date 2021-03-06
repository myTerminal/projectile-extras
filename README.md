# projectile-extras

[![Marmalade](https://img.shields.io/badge/marmalade-available-8A2A8B.svg)](https://marmalade-repo.org/packages/emacs-daily-events)  
[![License](https://img.shields.io/badge/LICENSE-GPL%20v3.0-blue.svg)](https://www.gnu.org/licenses/gpl.html)

A few extra functions for projectile

You can use *projectile-extras* as a supplement to projectile for a few extra functions.

## Installation

### Manual

Save the file *projectile-extras.el* to disk and add the directory containing it to `load-path` using a command in your *.emacs* file like:

    (add-to-list 'load-path "~/.emacs.d/")

The above line assumes that you've placed the file into the Emacs directory '.emacs.d'.

Start the package with:

    (require 'projectile-extras)

Note: You must have [projectile](https://github.com/bbatsov/projectile) for *projectile-extras* to work as it is an extension to it.

### Marmalade

If you have Marmalade added as a repository to your Emacs, you can just install *projectile-extras* with

    M-x package-install projectile-extras RET

## Usage

Currently *projectile-extras* provides the following functions:

 - projectile-find-all-occurrences  
Prompts for a text and lists all files in the current project containing it.
 
 - projectile-find-all-references  
Lists all files in the current project containing marked text.

## Dependencies

* [projectile](https://github.com/bbatsov/projectile)
