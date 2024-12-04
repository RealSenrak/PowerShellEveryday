# Prompt User for Source and Destination Folders
$SourceFolder = Read-Host "Enter the source folder path (e.g., B:\Steam\userdata\#########\###\remote\###\screenshots)"
$DestinationFolder = Read-Host "Enter the destination folder path (e.g., A:\Name\Pictures\Steam_Screenshots\CS2)"

# Validate Source Folder
if (!(Test-Path -Path $SourceFolder)) {
    Write-Host "Source folder does not exist. Please check the path and try again." -ForegroundColor Red
    exit
}

# Validate/Create Destination Folder
if (!(Test-Path -Path $DestinationFolder)) {
    Write-Host "Destination folder does not exist. Creating it now..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $DestinationFolder | Out-Null
}

# Get Today's Date for Folder Naming
$TodayFolder = Join-Path -Path $DestinationFolder -ChildPath (Get-Date -Format "yyyy-MM-dd")
if (!(Test-Path -Path $TodayFolder)) {
    New-Item -ItemType Directory -Path $TodayFolder | Out-Null
}

# Process Each .jpg File in the Source Folder
Get-ChildItem -Path $SourceFolder -Filter "*.jpg" -Recurse | ForEach-Object {
    # Extract Date Taken from Metadata (or fallback to CreationTime)
    $File = $_
    $DateTaken = ($_ | Get-ItemProperty).CreationTime
    $DateFolderName = $DateTaken.ToString("yyyy-MM-dd")
    $DateFolderPath = Join-Path -Path $DestinationFolder -ChildPath $DateFolderName

    # Ensure Date Folder Exists
    if (!(Test-Path -Path $DateFolderPath)) {
        New-Item -ItemType Directory -Path $DateFolderPath | Out-Null
    }

    # Move the File to the Corresponding Date Folder
    Move-Item -Path $_.FullName -Destination $DateFolderPath
}

Write-Host "Screenshots have been successfully organized!" -ForegroundColor Green
