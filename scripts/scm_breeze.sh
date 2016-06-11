export SCM_BREEZE_DIR="$HOME/.scm_breeeze"

if [ ! -d "$SCM_BREEZE_DIR" ]; then
    git clone git://github.com/ndbroadbent/scm_breeze.git $SCM_BREEZE_DIR
fi

source "$SCM_BREEZE_DIR/scm_breeze.sh"
