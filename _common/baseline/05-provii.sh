#!/bin/sh -ex

# [ 0o ] :: INSTALL & CONFIGURE PROVII
#
#   1a. mv: $PROVII_DIR (repo) -> `$XDG_DATA_DIRS/provii`
#   1b. add `$PROVII_DIR` to system environment (via `/etc/profile`)
#   2a. mkdir: `$XDG_CACHE_HOME/provii`, for intermediary installation files
#   2b. add `$PROVII_CACHE` to system environment (via `/etc/profile`)
#   3. symlink: `$XDG_DATA_DIRS/provii/provii` -> `$XDG_DATA_DIRS/bin/iinst`

RC_ORDER=3
RC_NAME='provii-vars'
RC_DEST='/etc/profile.d'

PROVII_RC=$( printf '%s/%d-%s.sh' $RC_DEST $RC_ORDER $RC_NAME )

PREFIX=${XDG_DATA_DIRS%%:*}

cat >> $PROVII_RC <<'EOD'
#!/bin/sh

# [ o0 ] : provii dirs required to run

export PROVII_{DIR,CACHE}
EOD

printf "\n%s\n" "PROVII_DIR=${PREFIX:?}/provii" >> $PROVII_RC

cat >> $PROVII_RC <<'EOF'
PROVII_CACHE=$HOME/.cache/provii
mkdir -pm 0600 $PROVII_CACHE 
EOF

. $PROVII_RC

mkdir -pm 0644 $PROVII_DIR
git clone srv:provii.git $PROVII_DIR \
    && make install
