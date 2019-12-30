# PEM to PFX
This is an extremely simple bash script that ingests a certificate, private key, CA bundle, and password, and spits out a PFX bundle:

The intent of creating this is to reduce the number of times one has to google "openssl convert pem to pfx" and dick around with `openssl` until you get exactly what you need. Any by 'you', I mean me.

# Installation

```bash
curl -s https://raw.githubusercontent.com/checktheroads/pem-to-pfx/master/install.sh | bash
```

...and then probably log out & back in, or run `source ~/.bashrc` or `source ~/.zshrc` as the case may be.

# Usage

## Options
```bash
Convert PEM bundle to PFX/PCKS12

    -h      Show this help menu.
    -c      Cert file name.
    -k      Key file name.
    -a      CA bundle file name.
    -o      Destination PFX file name.
    -p      Import/Export password.
    -f      Import/Export password file name. [OPTIONAL - default is current working directory]
    -d      Show debug output ⚠️  THIS WILL SHOW PASSWORDS ⚠️

```

## Conversion

```bash
pem-to-pfx \
    -c <path to cert file> \
    -k <path to key file> \
    -a <path to CA bundle file> \
    -o <path to new PFX file> \
    -p <private key password>
```

# License
<a href="http://www.wtfpl.net/"><img
       src="http://www.wtfpl.net/wp-content/uploads/2012/12/wtfpl-badge-4.png"
       width="80" height="15" alt="WTFPL" /></a>
