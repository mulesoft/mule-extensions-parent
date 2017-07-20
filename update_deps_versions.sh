#!/bin/sh

set -o nounset

updatePropertiesVersion() {
  VERSION_TO_PROPERTY="$1"
  POM_PROPERTY_PATH="$2"

  # PROPERTIES argument should be passed as a literal "arrayName[@]" without $ because here using the ! it is double expanded
  # to obtiain the values and declare again the array.
  PROPERTIES=("${!3}")

  echo "Updating deps in pom: $POM_PROPERTY_PATH"

  for PROPERTY_NAME in "${PROPERTIES[@]}"
  do

      perl -0777 -i -pe "s/(<properties>.*<$PROPERTY_NAME)(.*)(\/$PROPERTY_NAME>.*<\/properties>)/\${1}>$VERSION_TO_PROPERTY<\${3}/s" "$POM_PROPERTY_PATH"
      echo "- Updating property '$PROPERTY_NAME' version to '$VERSION_TO_PROPERTY'"

  done
}

VERSION_TO_DEPS=$1
VERSION_TO_MULE_RUNTIME=$2
VERSION_TO_DATAWEAVE=$3

# Properties with releaseVersion in the root pom.xml
propertiesDeps=("mule.sdk.version"
                "mule.api.version"
                "mule.metadata.version"
                "mule.extensions.maven.plugin.version"
                "mule.app.plugins.maven.plugin.version")

updatePropertiesVersion "$VERSION_TO_DEPS" pom.xml propertiesDeps[@]

propertiesDeps=("mule.version")

updatePropertiesVersion "$VERSION_TO_MULE_RUNTIME" pom.xml propertiesDeps[@]

propertiesDeps=("mule.weave.version")

updatePropertiesVersion "$VERSION_TO_DATAWEAVE" pom.xml propertiesDeps[@]
