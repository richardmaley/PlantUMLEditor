This is a windows application that edits PlantUML diagrams.  I am using Delphi 12.  It is Delphi/Pascal code.  It also uses the TEdgeBrowser, consequently it needs the WebView2Loader.dll.

Installation: 
Install this application in its own directory because the executable creates its required subdirectories when first run.
A directory called Images will be created to house PlantUml diagrams.  In the Images directory there is a subdirectory called Examples.  It has multiple *.puml examples.

Automatic Backups: 
By default the application automatically backs up diagram code and html code.  Backups are only made if there are changes since the last backup.  By default the backup location is a directory called "Backup" in the same location as the executable.  All of this can be controlled by editing the "Plantumleditor.ini" file.  This file is created the first time the executable "PlantUMLEditor.exe"  is run.  The ini settings that control backups are:

//This controls how often a backup is made. This is an integer in minutes.
inBackupFrequencyMins=1

//boAutoBackup enables or disables backups. Any value other than TRUE disables backups.
boAutoBackup=TRUE

//DirBackup is the full path to the backup directory.
DirBackup=S:\Documents\Delphi\Projects\Graphics\PlantUMLEditor\Backup\
