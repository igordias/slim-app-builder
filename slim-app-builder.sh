#!/bin/bash

# Static template information
TEMPLATE_GIT_LINK="https://github.com/melgarejojunior/app-template-android-slim.git"
TEMPLATE_PACKAGE_NAME="br.com.melgarejo.apptemplateslim"
TEMPLATE_PACKAGE_PATH="/br/com/melgarejo/apptemplateslim"
TEMPLATE_APP_ID="br.com.melgarejo.apptemplateslim"
TEMPLATE_APP_NAME="AppTemplateSlimApplication"
TEMPLATE_FOLDER_NAME="app-template-android-slim"
declare -a TEMPLATE_FOLDERS=(
    "./app-template-android-slim/app/src/androidTest/java${TEMPLATE_PACKAGE_PATH}"
    "./app-template-android-slim/app/src/test/java${TEMPLATE_PACKAGE_PATH}"
    "./app-template-android-slim/app/src/main/java${TEMPLATE_PACKAGE_PATH}"
)

# Reads new project information
printf "\n\nApplication name (eg. TestFlightApplication):\n"
read applicationName

printf "\nRemote origin (eg.: git@gitlab.com:igordias/my-new-project.git):\n"
read remoteOrigin

printf "\nPackage name (eg.: com.igordias.testflightapplication):\n"
read packageName

# Derives project name from remote origin (between slash and .git)
projectName=$(sed 's/.*\/\(.*\).git.*/\1/' <<< $remoteOrigin)

# Derives a package path from the packageName by replacing dots by slashes
packagePath="/${packageName//.//}"

declare -a NEW_APP_FOLDERS=(
    "./app-template-android-slim/app/src/androidTest/java${packagePath}"
    "./app-template-android-slim/app/src/test/java${packagePath}"
    "./app-template-android-slim/app/src/main/java${packagePath}"
)

# Clones app template from git
git clone $TEMPLATE_GIT_LINK

# Replaces $TEMPLATE_PACKAGE_NAME by $packageName in each .kt, .java and .xml file
find ./app-template-android-slim -type f -name "*.kt" | xargs sed -i '' "s/$TEMPLATE_PACKAGE_NAME/$packageName/g"
find ./app-template-android-slim -type f -name "*.java" | xargs sed -i '' "s/$TEMPLATE_PACKAGE_NAME/$packageName/g"
find ./app-template-android-slim -type f -name "*.xml" | xargs sed -i '' "s/$TEMPLATE_PACKAGE_NAME/$packageName/g"

# Renames the application id on gradle files
find ./app-template-android-slim -type f -name "*.gradle" | xargs sed -i '' "s/$TEMPLATE_APP_ID/$packageName/g"

# Renames application
find ./app-template-android-slim -type f -name "*.xml" | xargs sed -i '' "s/$TEMPLATE_APP_NAME/$applicationName/g"
find ./app-template-android-slim -type f -name "*.kt" | xargs sed -i '' "s/$TEMPLATE_APP_NAME/$applicationName/g"
mv ./app-template-android-slim/app/src/main/java${TEMPLATE_PACKAGE_PATH}/presentation/$TEMPLATE_APP_NAME.kt ./app-template-android-slim/app/src/main/java${TEMPLATE_PACKAGE_PATH}/presentation/$applicationName.kt

# Creates the necessary folders and moves files to them
FOLDER_INDEX=0
for folder in "${TEMPLATE_FOLDERS[@]}"
    do
        from=$folder"/*"
        to=${NEW_APP_FOLDERS[FOLDER_INDEX]}
        temporaryFolder="./app-template-android-slim/temporary"
        
        #Moves files to temporary safe folder
        mkdir $temporaryFolder
        mv $from $temporaryFolder

        # Deletes old template dir - that's why we need a temporary folder to make sure com.something projects won't get accidentaly deleted
        PATH_TO_REMOVE="${folder//$TEMPLATE_PACKAGE_PATH}"
        rm -r $PATH_TO_REMOVE

        #Moves files from temporary safe folder to final folder
        mkdir -p $to
        mv $temporaryFolder/* $to
        rm -r $temporaryFolder

        printf ${PATH_TO_REMOVE}"\n"
        printf ${to}"\n"
        FOLDER_INDEX=$((FOLDER_INDEX+1))
    done

# Renames project folder
mv $TEMPLATE_FOLDER_NAME $projectName

# Extremely important SW quote for the first commit.
declare -a STAR_WARS_QUOTES=(
    "Oh, my dear friend. How I’ve missed you."
    "Chewie, we’re home."
    "Great, kid. Don’t get cocky."
    "You came in that thing? You’re braver than I thought."
    "Now, witness the power of this fully operational battle station."
    "Much to learn you still have… my old Padawan."
    "He’s the brains, sweetheart!"
)
randomSwQuote=${STAR_WARS_QUOTES[$RANDOM % ${#STAR_WARS_QUOTES[@]}]}

# Pushes to new project's repository on git
cd $projectName
git remote rename origin old-origin
git remote add origin $remoteOrigin

git add .
git commit -m "$randomSwQuote"

git push -u origin --all
git push -u origin --tags
