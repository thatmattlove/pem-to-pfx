# PFX to PEM
This is an extremely simple bash script that ingests a PFX bundle and spits out individual PEM files of the contained:

- Certificate
- Unencrypted Private Key
- CA chain (intermediate & root)
- Private key password

The intent of creating this is to reduce the number of times one has to google "openssl convert pfx to pem" and dick around with `openssl` until you get exactly what you need. Any by 'you', I mean me.

# Installation

# Usage

# License
<a href="http://www.wtfpl.net/"><img
       src="http://www.wtfpl.net/wp-content/uploads/2012/12/wtfpl-badge-4.png"
       width="80" height="15" alt="WTFPL" /></a>
