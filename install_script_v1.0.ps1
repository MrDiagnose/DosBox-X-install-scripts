<#set default output encoding of >>/> to utf8#>
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'


$_folder_ = "win98_scripts" <#change folder name here#>

<#Checks if win98_scripts folder exists or not#>
if (Test-Path $_folder_){
    Write-Host "Folder Already Exists"
}
else
{
    New-Item $_folder_ -ItemType Directory
    Write-Host "Folder Created Successfully"
}

$win98_conf={[sdl]
autolock=true

[dosbox]
title=Windows 98
memsize=128

[video]
vmemsize=8
vesa modelist width limit=0
vesa modelist height limit=0

[dos]
ver=7.1
hard drive data rate limit=0
floppy drive data rate limit=0

[cpu]
cputype=pentium_mmx
core=normal

[sblaster]
sbtype=sb16vibra

[fdc, primary]
int13fakev86io=true

[ide, primary]
int13fakeio=true
int13fakev86io=true

[ide, secondary]
int13fakeio=true
int13fakev86io=true
cd-rom insertion delay=4000

[render]
scaler=none

[autoexec]}


$hdd_size = Read-Host -Prompt "Enter HDD in gigabytes eg 1 for 1gb ,2 for 2gb etc " 
$hdd = "hd_"+$hdd_size+"gig"


$install_command={IMGMOUNT C win98.img
IMGMOUNT D win98.iso
IMGMOUNT A -bootcd D
BOOT A:}

<#create *.conf file named win98_install.conf#>
echo $win98_conf > "$_folder_\win98_install.conf"
echo "IMGMAKE win98.img -t $hdd" >> "$_folder_\win98_install.conf"
echo $install_command >> "$_folder_\win98_install.conf"


$run_command={IMGMOUNT C win98.img
IMGMOUNT D Win98.iso
BOOT C:}

<#create *.conf file named win98_run.conf#>
echo $win98_conf > "$_folder_\win98_run.conf"
echo $run_command >> "$_folder_\win98_run.conf"


$run_script={start .\dosbox-x.exe -conf .\win98_run.conf
exit}

<#create executable batch file#>
echo "@echo off" > run_win98.bat
echo "$run_script" >> run_win98.bat

<#run the install script using dosbox-x#>
.\dosbox-x.exe -conf "$_folder_\win98_install.conf"