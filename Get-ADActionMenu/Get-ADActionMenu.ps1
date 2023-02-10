$MyMenu = $true
while ($MyMenu){
    write-host "----------------------What do you want to do?---------------------"
    write-host "#                        1: Search User Data                     #"
    write-host "#               2: Search Multiple Users Data From CSV           #"
    write-host "#                              x: exit                           #"
    write-host "------------------------------------------------------------------"
    $MenuChoice = Read-Host "Choose an option:"
    switch ($MenuChoice){
        # Search for a user's data in AD
        # This will output the username, First Name, Last Name, User Name, Email, and Phone Number
        1{ 
          
            # Get the user's ID
            $UserId = Read-Host "Enter the user's ID (example VDL07164): "

            # Get the user's data from the Active Directory
            Get-ADUser -Identity $UserId  
                       -Properties * | Select-Object Name, #VDL07164
                                                     displayname, #Mashiro3131
                                                     UserPrincipalName, #mashiro3131@gmail.com
                                                     telephoneNumber, # +xx (0) xx xx xx xx
                                                     Department, # IT
                                                     StreetAddress, # Somwhere In The World 66
                                                     extensionAttribute1, # Environment and Infrastructure
                                                     extensionAttribute2, # Organization and IT
                                                     extensionAttribute3, # Developpement
                                                     extensionAttribute9  # 15th floor
        
        }

        # Loops through a CSV file to find the users in the active directory then outputs the data to a new CSV file
        2{ 
        
# Open's the file explorer to select the CSV file
$openFile = New-Object System.Windows.Forms.OpenFileDialog
$openFile.Filter = "CSV Files (*.csv)|*.csv"
$openFile.Title = "Select the CSV file"
$openFile.ShowDialog()
$csv = $openFile.FileName
$csvImport = import-csv -Path $csv -UseCulture
$UserIds = $csvImport.Username

# Loops through the CSV file to find the users in the active directory
$FinalUsers = foreach ($UserId in $UserIds){
Get-ADUser `
    -Identity $UserId `
    -Properties * | Select-Object Name, #VDL07164
                                  displayname, #Mashiro3131
                                  UserPrincipalName, #mashiro3131@gmail.com
                                  telephoneNumber, # +xx (0) xx xx xx xx
                                  Department, # IT
                                  StreetAddress, # Somwhere In The World 66
                                  extensionAttribute1, # Environment and Infrastructure
                                  extensionAttribute2, # Organization and IT
                                  extensionAttribute3, # Developpement
                                  extensionAttribute9  # 15th floor
} 

# Open's the file explorer to choose how to name and where to save the CSV file
$saveFile = New-Object System.Windows.Forms.SaveFileDialog
$saveFile.Filter = "CSV Files (*.csv)|*.csv"
$saveFile.Title = "Save the CSV file"
$fileName = Read-Host "Enter the name of the file: "
$saveFile.FileName = $fileName
$saveFile.ShowDialog()
$saveFile.FileName
$FinalUsers | Export-Csv -Path $saveFile.FileName -Encoding UTF8 -Delimiter ";" -Force
Write-Host "The results have been exported to $saveFile.FileName" -ForegroundColor Green

        }
        'x'{$MyMenu = $false}
        default {Write-Host "Invalid choice"-ForegroundColor Red}
    }
}