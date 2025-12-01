FIREFOX_DIR=~/.mozilla/firefox
if [[ $(grep '\[Profile[^0]\]' ${FIREFOX_DIR}/profiles.ini) ]]
then PROFPATH=$(grep -E '^\[Profile|^Path|^Default' ${FIREFOX_DIR}/profiles.ini | grep -1 '^Default=1' | grep '^Path' | cut -c6-)
else PROFPATH=$(grep 'Path=' ${FIREFOX_DIR}/profiles.ini | sed 's/^Path=//')
fi

if [ ! -d "${FIREFOX_DIR}/${PROFPATH}/chrome" ] || [ ! -f "${FIREFOX_DIR}/${PROFPATH}/chrome/userChrome.css" ]; then
  mkdir ${FIREFOX_DIR}/${PROFPATH}/chrome;
  cp ~/.dotfiles/firefox/userChrome.css "${FIREFOX_DIR}/${PROFPATH}/chrome/userChrome.css"
fi

