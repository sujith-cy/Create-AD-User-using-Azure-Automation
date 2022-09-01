#Create AD User using Azure Automation

param(
    [Parameter(Mandatory=$True)] $User,
    [Parameter(Mandatory=$True)] $Firstname,
    [Parameter(Mandatory=$True)] $Lastname,
    [Parameter(Mandatory=$True)] $OU,
    [Parameter(Mandatory=$True)] $city,
    [Parameter(Mandatory=$True)] $company,
    [Parameter(Mandatory=$True)] $state,
    [Parameter(Mandatory=$True)] $streetaddress,
    [Parameter(Mandatory=$True)] $telephone,
    [Parameter(Mandatory=$True)] $jobtitle,
    [Parameter(Mandatory=$True)] $department
)


# Import active directory module for running AD cmdlets
#Import-Module activedirectory

#Store the data from ADUsers.csv in the $ADUsers variable


# Function

function Get-RandomCharacters($length, $characters) {
    $random = 1..$length | ForEach-Object { Get-Random -Maximum $characters.length }
    $private:ofs=""
    return [String]$characters[$random]
}
 
function Scramble-String([string]$inputString){     
    $characterArray = $inputString.ToCharArray()   
    $scrambledStringArray = $characterArray | Get-Random -Count $characterArray.Length     
    $outputString = -join $scrambledStringArray
    return $outputString 
}
  
# Generate Password
$password = Get-RandomCharacters -length 5 -characters 'abcdefghiklmnoprstuvwxyz'
$password += Get-RandomCharacters -length 4 -characters 'ABCDEFGHKLMNOPRSTUVWXYZ'
$password += Get-RandomCharacters -length 3 -characters '1234567890'
$password += Get-RandomCharacters -length 3 -characters '!"§$%&/()=?}][{@#*+'
$password = Scramble-String $password
$secureString = convertto-securestring $password -asplaintext -force


	#Check to see if the user already exists in AD
	if (Get-ADUser -F {SamAccountName -eq $User})
	{
		 #If user does exist, give a warning
		 Write-Warning "A user account with username $User already exist in Active Directory."
	}
	else
	{
		#User does not exist then proceed to create the new user account
		
        #Account will be created in the OU provided by the $OU variable read from the CSV file
	New-ADUser `
            -SamAccountName $User `
            -UserPrincipalName "$User@azureessentials.in" `
            -Name "$Firstname $Lastname" `
            -GivenName $Firstname `
            -Surname $Lastname `
            -Enabled $True `
            -DisplayName "$Lastname, $Firstname" `
            -Path $OU `
            -City $city `
            -Company $company `
            -State $state `
            -StreetAddress $streetaddress `
            -OfficePhone $telephone `
            -EmailAddress "$User@azureessentials.in" `
            -Title $jobtitle `
            -Department $department `
            -AccountPassword $secureString -ChangePasswordAtLogon $True
            #If user is created, show message.
            Write-Host "The user account $Username is created." -ForegroundColor Cyan
            #If user is created, show message.
            Write-Host "The user account $User is created." -ForegroundColor Cyan

}
