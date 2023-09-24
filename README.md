# crow

## Goal

A tool which allows the user to store text informations (e.g. passwords or notes), images and other files (e.g., VPN connection files) in a password protected and encrypted storage.

## Research

There are two options to reach the goal:

- Option A: Use a file archvie which supports password and encryption to directly secure all kind of files (e.g. ZIP).
- Option B: Serialize all kind of files and store them in an secured database (e.g. KeePass).

### Similar Solutions

- [File Lock PEA - Filesystem-Level Encryption](https://eck.cologne/peafactory/en/html/file_pea.html)
- [Hat.sh - file encryption](https://hat.sh/)
- [Share a secret](https://scrt.link/)

### iOS

#### Storage

- https://stackoverflow.com/questions/44604313/save-files-inside-app-folder
- https://iosdevcenters.blogspot.com/2016/04/save-and-get-image-from-document.html

#### Zip Libary

| Libary | In-Momory Support | Password Support |
|---|---|---|
| [weichsel/ZIPFoundation](https://github.com/weichsel/ZIPFoundation) | [X] | [ ] | 
| [ZipArchive/ZipArchive](https://github.com/ZipArchive/ZipArchive) | [ ] | [X] |
| [marmelroy/Zip](https://github.com/marmelroy/Zip) | [ ] | [X] |

