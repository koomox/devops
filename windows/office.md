# Install Microsoft Office 2024 using the Office Deployment Tool                             
Office Deployment Tool [Link](https://www.microsoft.com/en-us/download/details.aspx?id=49117)                 
Office Customization Tool [Link](https://config.office.com/)                         

Download Microsoft Office 2024
```bat
setup /download configuration.xml
```
Install Microsoft Office 2024
```bat
setup /configure configuration.xml
```  
```xml
<Configuration ID="75ec6cf0-e82b-4890-b44f-cff1b76381b3">
  <Add OfficeClientEdition="64" Channel="PerpetualVL2024">
    <Product ID="ProPlus2024Volume" PIDKEY="XJ2XN-FW8RK-P4HMP-DKDBV-GCVGB">
      <Language ID="en-us" />
      <ExcludeApp ID="Access" />
      <ExcludeApp ID="Lync" />
      <ExcludeApp ID="OneDrive" />
      <ExcludeApp ID="OneNote" />
      <ExcludeApp ID="Outlook" />
      <ExcludeApp ID="Publisher" />
    </Product>
  </Add>
  <Property Name="SharedComputerLicensing" Value="0" />
  <Property Name="FORCEAPPSHUTDOWN" Value="FALSE" />
  <Property Name="DeviceBasedLicensing" Value="0" />
  <Property Name="SCLCacheOverride" Value="0" />
  <Property Name="AUTOACTIVATE" Value="1" />
  <Updates Enabled="TRUE" />
  <RemoveMSI />
  <Display Level="Full" AcceptEULA="TRUE" />
</Configuration>
```