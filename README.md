# dotfiles

My dotfiles for [Garuda Linux](https://garudalinux.org/)

## Usage

You'll need the [https://github.com/thoughtbot/rcm](rcm) package to run the following commands.

To add a new file to dotfile managament run `mkrc -v <path to the file or directory you want to backup>`, e.g. `mkrc -v ~/.bashrc`.

To apply the files from this repository to your local machine's dotfiles run `rcup`. You can also specify a path or directory: `rcup -v .bashrc`.
