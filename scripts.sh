#!/bin/bash

set -e

# Base directory for this entire project
BASEDIR=$(cd $(dirname $0) && pwd)

# Read the entered command
command=${1:-empty}

if [ $command == install ]
	then

		# -----------------------------------------------------------------
		# (1) install, link with semantic-ui less styles
		# -----------------------------------------------------------------

    printf '%s\n' "Create semantic-ui theme config file @ node_modules/semantic-ui/src/theme.config"

    echo '/* Reference the websemantics/strong-together app config file */
@import "resources/assets/less/semantic/theme.config";
/* End Config */' > "$BASEDIR/node_modules/semantic-ui/src/theme.config"

elif [ $command == deploy ]
	then

    # ---------------------------------------------------------------------------
		# (2) Deploy, the following bash will deploy this app to the repo gh-page
		# ---------------------------------------------------------------------------

		printf '%s\n' "Create semantic.json file and semantic folder for quite semantic-ui install"

		mkdir -p "$BASEDIR/semantic/src/definitions"
		echo '' > "$BASEDIR/semantic/src/theme.config"
		echo '{"base":"semantic/","paths":{"source":{"config":"src/theme.config","definitions":"src/definitions/","site":"src/site/","themes":"src/themes/"},"output":{"packaged":"dist/","uncompressed":"dist/components/","compressed":"dist/components/","themes":"dist/themes/"},"clean":"dist/"},"permission":false,"rtl":false}' > "$BASEDIR/semantic.json"

		npm install
		npm run build

    # Create a new Git repo in public folder
    cd "$BASEDIR/public"
    git init

    # Set user details
    git config user.name "iAyeBot"
    git config user.email "iayebot@websemantics.ca"

    # First commit, .. horray!
    git add .
    git commit -m "Deploy to gh-pages"

    # Force push ...
    git push --force --quiet "https://${GH_TOKEN}@${GH_REF}" master:gh-pages > /dev/null 2>&1

    printf '%s\n' "All done, .."

  else

		# -----------------------------------------------------------------
		# (3) Nothing, show something .. anything ..
		# -----------------------------------------------------------------

		printf '%s\n%s\n' "Please type a valid command option:" "(1) install  or (2)"
fi
