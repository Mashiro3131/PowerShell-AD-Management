$MyMenu = $true
while ($MyMenu) {
    write-host "--------------------What would you like to do ?-------------------"
    write-host "#                        1: Search User Data                     #"
    write-host "#               2: Search for Multiple Users from CSV            #"
    write-host "#                              x: exit                           #"
    write-host "------------------------------------------------------------------"
    $MenuChoice = Read-Host "Choose an option:"
    switch ($MenuChoice) {
        # Search for a user's data in AD
        # This will output the username, First Name, Last Name, User Name, Email, and Phone Number
        1 { 
          
            # Asks for the user's ID
            $UserId = Read-Host "Enter the user's ID (ex: VDL07164) "
            Get-ADUser `
            -Identity $UserId `
            -Properties * | Select-Object Name, #MSHIRO3131
                                          displayname, # Nico Mengisen
                                          UserPrincipalName, #mashiro3131@gmail.com
                                          telephoneNumber, # +xx (0) xx xx xx xx
                                          Department, # Organization and IT
                                          extensionAttribute1, # Environment and Infrastructure
                                          extensionAttribute3, # Developpement
                                          StreetAddress, # Somwhere In The World 66
                                          extensionAttribute9  # 15th floor

            # You can add more attributes by typing the following command : Get-ADUser -Properties * TheUserYouWantToSearch
            # The attributes will be displayed on the left (someattribute : somevalue)
        }

        # Loops through a CSV file to find the users in the active directory then outputs the data to a new CSV file
        2 {
            # Open's the file explorer to select the CSV file
            $openFile = New-Object System.Windows.Forms.OpenFileDialog
            $openFile.Filter = "CSV Files (*.csv)|*.csv"
            $openFile.Title = "Select the CSV file"
            $openFile.ShowDialog()
            $csv = $openFile.FileName
            $csvImport = import-csv -Path $csv -UseCulture
            $UserIds = $csvImport.Username

            # Initializes the loading bar
            $i = 0
            $total = $UserIds.Count
            Write-Progress -Activity "Searching for users" -Status "Please wait..." -PercentComplete 0



            # Loops through the CSV file to find the users
            $FinalUsers = foreach ($UserId in $UserIds){


            # Updates the loading bar
            $i++
            $percent = [math]::Round(($i / $total) * 100, 0)
            Write-Progress -Activity "Searching for users" -Status "Please wait..." -PercentComplete $percent


                # Outputs the data to a new CSV file
                Get-ADUser `
                -Identity $UserId `
                -Properties * | Select-Object Name, #MSHIRO3131
                                              displayname, # Nico Mengisen
                                              UserPrincipalName, #mashiro3131@gmail.com
                                              telephoneNumber, # +xx (0) xx xx xx xx
                                              Department, # Organization and IT
                                              extensionAttribute1, # Environment and Infrastructure
                                              extensionAttribute3, # Developpement
                                              StreetAddress, # Somwhere In The World 66
                                              extensionAttribute9  # 15th floor

<#

To change a header name change these lines : @{Name="TheHeaderYouWant";Expression={$_.TheProperty}}}

                Get-ADUser `
                -Identity $UserId `
                -Properties * | Select-Object @{Name="Username";Expression={$_.SamAccountName}}, # The header will be Username and the value will be MSHIRO3131
                                              @{Name="First Name";Expression={$_.GivenName}},
                                              @{Name="Last Name";Expression={$_.Surname}},
                                              @{Name="Email";Expression={$_.UserPrincipalName}},
                                              @{Name="Direction";Expression={$_.extensionAttribute1}},
                                              @{Name="Services";Expression={$_.Department}}
#>
} 

# Open's the file explorer to choose how to name and where to save the CSV file
$saveFile = New-Object System.Windows.Forms.SaveFileDialog
$saveFile.Filter = "CSV Files (*.csv)|*.csv"
$saveFile.Title = "Save the CSV file"
$fileName = Read-Host "How do you want to call the file "
$saveFile.FileName = $fileName
$saveFile.ShowDialog()
$saveFile.FileName
$FinalUsers | Export-Csv -Path $saveFile.FileName -Encoding UTF8 -Delimiter ";" -Force
Write-Host "The results have been exported to $saveFile.FileName" -ForegroundColor Green

        }

        'x'{$MyMenu = $false}
        default {
            Write-Host "Invalid choice"-ForegroundColor Red
        }

    }
}