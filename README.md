# Subscriptions extractor

## Requirements

On Linux and Mac OS, you need to install `git`, `unzip` and `sqlite3`.
On Android you need to install Termux and in Termux you then need to install `git`, `unzip` and `sqlite3`.
On Windows you need to enable the Ubuntu subsystem and then install `git`, `unzip` and `sqlite3` from there.

## Usage

Open a terminal and run the following commands:

``` bash
git clone https://github.com/T-vK/subscriptions-extractor.git
cd subscriptions-extractor
bash subscriptions-extractor.sh path/to/your/inputfile > output.xml
```

`path/to/your/inputfile` can be a path to one of these:

- `sbscriptions.db` (FreeTube before the 2020 rewrite)
- `NewPipeData-........zip` (NewPipe)
- `skytube-...............skytube` (Skytube)
- `subs.db` (Skytube)
- `newpipe.db` (NewPipe)

`output.xml` is the file to which is created or overwritten and will contain all your subscriptions in the youtube xml format.
