# Chaotic AUR

## CLI

- `chaotic pr{,epare} ${INPUTDIR} $@`

  It generates a building script to be later run in a containerized environment.
  `$INPUTDIR` is the name of directory in "$PWD" which contains a PKGBUILD.

- `chaotic {lw,lowerstrap}`

  It generates a lowerdir for later chrooting.

- `chaotic {mk,makepkg} ${INPUTDIR} $@`

  Builds the package in a container using systed-nspawn.
  `$INPUTDIR` is the result of a `prepare`

- `chaotic {mkd,makepwd} $@`

  Prepare and build all packages in the current directory.

- `chaotic {si,iterfere-sync}`

  Sync packages' interference repo.

- `chaotic {dp,deploy} ${INPUTDIR}`

  Sign the package and send to primary node.

- `chaotic {dbb,db-bump}`

  Add recently deployed packages to the database, while moving replaced packages to archive.
  Uses `repoctl`.

- `chaotic {rm,remove} ${PACKAGES[@]}`

  Remove and archive all listed packages.
  Uses `repoctl`.

- `chaotic {get,aur-download} [-r] ${PACKAGES[@]}`

  Download listed packages' sources from AUR.
  Uses `repoctl`.

- `chaotic {kt,key-trust} ${KEYS[@]}`

  Add some key to keyring.
  Uses `gpg`

- `chaotic cl{,eanup} ${INPUTDIR}`

  Safely deletes old package sources.

- `chaotic help {syncthing,rsync}`

  Instructions to the mirroring services.
  RSync is one-way (primary->cluster) only, and Syncthing both ways.

## Involved directories

- `/var/cache/chaotic/sources/${PACKAGETAG}`

  Per-package `SRCDEST`.

- `/var/cache/chaotic/lower/{latest,$DATESTAMP}`

  Lowerdirs.

- `/var/cache/chaotic/cc/{PACKAGETAG}`

  Per-package `~/.ccache`.

- `/var/cache/chaotic/packages`

  Container-shared pacman's cache.

- `/var/lib/chaotic/interfere`

  Cloned version of [interfere repository](https://github.com/chaotic-aur/interfere)

# Dependencies

`pacman -S --needed base-devel git arch-install-scripts repoctl`

One must have an active mirror of chaotic-aur running locally and some signing key. Configure them in `/etc/chaotic.conf`, like this:

```sh
export CAUR_DEST_PKG="/var/www/chaotic-aur/x86_64"
export CAUR_URL="http://localhost:8080/chaotic-aur/x86_64"
export CAUR_SIGN_KEY='8A9E14A07010F7E3'
export CAUR_TYPE='cluster'
```

You'll find more options in `src/chaotic` first lines.

Supported `type` values are: `primary`, `cluster`, and `dev`.

## Installation

`sudo make install`
