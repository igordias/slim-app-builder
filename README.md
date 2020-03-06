# Slim app builder

This project aims to aid Android project setups based on the Slim Template made by [@melgarejojunior](https://github.com/melgarejojunior).

## What it does

1. Clones Melgarejo's Slim App Template repository
2. Creates folders and renames the packages based on your applications name
3. Takes care of the packaging name reference on Kotlin and Java files
4. Pushes the project to a specified Git repository

## How to use it

1. Create a new project on GitLab and copy its remote origin
2. Run the slim-app-builder script
   1. Insert your application class name (eg.: TestFlightApplication)
   2. Insert your new project's remote origin (eg.: git@gitlab.com:igordias/my-new-project.git)
   3. Insert a Package name (eg.: com.igordias.testflightapplication) 