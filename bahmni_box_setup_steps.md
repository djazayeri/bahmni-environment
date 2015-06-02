Guide To INSTALL Bahmni Software on a CentOS Minimal System
===============================================================
1. Install CentosOS (Minimal) 
  http://wiki.centos.org/Manuals/ReleaseNotes/CentOSMinimalCD6.5
  For example:
  download "CentOS-6.5-x86_64-minimal.iso" from http://centos.mirror.net.in/centos/6.5
  
  IF YOU ARE INSTALLING IN A VM THEN: 
    - In Virtual Box create a new Virtual Image (Bahmni_CentOS) and give its type as Red Hat Linux with 1.5GB RAM and 20 GB Virtual HDD. Leave other options as default.
    - Click on "Storage" window and select new CD/DVD drive option, to specify the CentOS ISO Image which you downloaded.
    - Start the newly created virtual box image. It will show you the INSTALL Wizard for CentOS.

  NOTE: 
    1. It is mandatory to choose CentOS MINIMAL, so that no older versions of software like PostGRES or JAVA get installed. These will otherwise conflict with the current puppet scripts. Its best to have just a basic system, and let the puppet scripts do all the installations.
    2. If you need to have a UI / Browser also running on this machine, then choose CentOS MINIMAL + DESKTOP. Note in this case "Java" might get selected. De-select JAVA while installing CentOS, so that it doesn't conflict with Bahmni version of Java.

2. Check if properly networked.
    1. In VirtualBox, choose bridged network to connect to internet.
    2. Run "ifconfig" and make sure eth0 has proper IP. You should be able to ping google. Else try "ifup eth0". Check ifconfig again.

  NOTE: Step 3, 4, 5, 6 and 9 can be done by running the "bootstrap.py" script in bahmni-environment. Or you can do them manually as mentioned below.

3. Install ruby (1.8.7)
    ```
    sudo yum install ruby
    ```

4.  Install Puppet - (http://docs.puppetlabs.com/guides/installation.html#red-hat-enterprise-linux-and-derivatives)
    ```
    sudo rpm -ivh http://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-7.noarch.rpm
    sudo yum install puppet
    ```

5.  Get Bahmni-Environment which contains Puppet provision scripts:

    a) Install git
      ```
      sudo yum install git
      ```
    b) Clone Bahmni-Environment repo in /root/bahmni -
      ```
      mkdir -p /root/bahmni
      cd /root/bahmni
      git clone https://github.com/Bhamni/bahmni-environment.git
      cd bahmni-environment
      ```


6. Install wget (if its not already present)
  ```
  sudo yum install wget
  ```

7. Mkdir /packages

8. Copy localrepo, servers, tools, Python-packages folders to /packages/
  ```
  scp -r root@bahmni-repo.twhosted.com:/packages/{localrepo,servers,tools,python-packages} /packages
  ```
  Change permissions of the packages folder
  ```
  chmod 777 -R /packages
  ```
    
  - Note: If you are going to run the provisioning without internet, then ensure that all existing yum repos are disabled 
    including, base, updates and extra repos by editing the files in /etc/yum.repos.d/ and adding enabled=0 line to each repo.
    Then run the command yum repolist enabled to see that none are enabled (except local which will be created by the provision command)


9. Set the following environment variables (which will be used by Puppet during provisioning). 
   For future, it might be best to set this permananently in your ~/.bashrc file. Configure as per needs.
    ```
    export FACTER_bahmni_user_name=bahmni  (default is bahmni)
    export FACTER_implementation_name=default (default is default)
    export FACTER_deploy_bahmni_openerp=true (default is false)
    export FACTER_deploy_bahmni_openelis=true (default is false)
    ```
    Also set the $support_email and $from_email variables in stack-runtime.properties file to appropriate value if you don't like the defaults.
    Run the command 
    ```
    hostname
    ```
    Copy the output and add it to the /etc/hosts file in the corresponding localhost(127.0.0.1) entry.
    


10. Run Provision Command (note: ensure that bahmni_user variable is set to bahmni/jss as you prefer)
  ```
  cd /root/bahmni/bahmni-environment
  ./scripts/run-puppet-manifest.sh provision
  ```

11. 
    Create openmrs db (user root/password): openmrs
    Create OpenERP DB: (psql with user postgres and then grant owner to openerp): openerp
    (ALTER DATABASE OPENERP OWNER TO OPENERP)


12. Download & install latest BAHMNI build from CI. This will download 2 installers: all_installer.sh (MRS, ELIS & ERP), [implementation_name]_config_installer.sh (the implementation config setup in the environment variable, eg: default)
  ```
  mkdir -p /packages/build
  ./scripts/download-build.sh
  ```
    

13. Deploy the Implementation Specific Builds (will read your implementation_name variable to decide which one to install)
  ```
  ./packages/build/all_installer.sh
  ./packages/build/[implementation_config_installer.sh]
  ```
  Note: If on deploy you get an error for JDK or tools.jar, ensure your default java is latest 1.7, and not old java1.5. If it is, then rename old java and create new sym link: 'ln -s /usr/java/default/bin/java /usr/bin/java'.       


14. JASPER REPORTS
    ----------------
    To deploy Jasper Reports, perform the following steps from bahmni-environment folder:
    - Check if you can access jasper reports: 
    ```
    http://<IP>:8080/jasperserver/ (jasperadmin/jasperadmin)
    ```
    - If you can't, then from webapps folder in tomcat, delete the 'jasperserver' folder and run the following command (stop tomcat):
    ```
    ./scripts/run-puppet-module.sh jasperserver
    ```
    - Now check that after restart of tomcat, the Jasper server URL is accessible.
    - Now deploy appropriate reports (this command reads the IMPLEMENTATION_NAME variable to decide which reports to deploy): 
    ```
    ./scripts/run-puppet-module.sh bahmni_jasperreports
    ```

15. Login to OpenERP using URL: http://<IP>:8069/ 
    Use credentials admin/admin or admin/password.
    NOTE: If credentials are admin/admin, then CHANGE THEM to admin/password.
    (Click on Administrator name on top right corner -> Preferences -> Change password)
    This is required, because default ATOM Feed expects admin/password as credentials.

16. 
    Check if the following URLs are accessible:
    (May need to restart the box once)
    OpenERP:                      http://<IP>:8069/ (admin/password)
    OpenMRS:                      https://<IP>/openmrs  (admin/test)
    OpenELIS:                     http://<IP>:8080/openelis/ (admin/adminADMIN!)
    Bahmni:                       http://<IP>/home (admin/test) --- May need to give roles to user in OpenMRS if you see blank dashboard
    Reference Data (Grails app):  http://<IP>/reference-data/
    Jasper Reports:               http://<IP>:8080/jasperserver/ (jasperadmin/jasperadmin)

    NOTE: To switch off IPTables in case your browser can't hit: 'service iptables stop'

17. Misc Configuration Steps:
    -------------------------
    - OpenELIS needs an Organization to be defined. Right now its JSS, but will need to be different per implementation. Do this in "Administration" screen.
    - The ATOM Feed properties file for elis needs organization entry. Set this to appropriate value:
    reference.data.default.organization=JSS (or set environment variable ELIS_DEFAULT_ORGANIZATION_NAME to appropriate value to override this.)
    (openelis/WEB-INF/classes/atomfeed.properties)
    - There is an issue with Address Hierarchy, so if you don't see the Registration Screen, then in OpenMRS, navigate to Address Hierarchy Screen. This will fix the issue.
    - You may also need to add "Health Centers" in ELIS, with appropriate ID prefixes. 

18. For OpenERP, follow these steps post-install:
    
    >> Remove the line "update --all" from "sudo vi /etc/init.d/openerp" file.
   
      1) Install the following Modules:  
        - Warehouse Management Module
        - Sales Management Module
        - Purchase Management Module
        - Accounting and Finance Module
        - SEARCH Reports Module (if you want these Accounting reports)

      When asked about the Financial Account system choose: (INR, 0, 0, Indian Account System)

      2) Setting -> config -> warehouse -> Enable the following:
        
        - Track Serial Number on Products, 
        - Expiry Date on Serial Number, 
        - Manage Multiple Location, 
        - Manage different  unit of measures on Products
      
      3) Settings -> config -> General Settings -> Allow user to import data from csv files
      4) Settings -> Users -> Administrator choose (Edit) — Access rights -> enable Technical Features. 

      5) Logout from OpenERP and then re-Login
      6) Go to Settings -> Modules -> Update Module List (Updated)
      7) Restart OpenERP ('sudo service openerp stop',  and then 'sudo service openerp start')
      8) Go to Settings -> Modules -> Installed Modules and in search box type "Bahmni"
          - Install 'Bahmni Module Install' (which installs all Bahmni OpenERP dependent modules)
          
          Ensure these are also installed: 
            - Bahmni Purchase flow enhancement
            - Bahmni Print Bill

          - Don't install Bahmni Seed Data install (Since it contains JSS specific stuff)
          - Don’t install Lab seed data
          - Don’t install DHIS2 stock export
      9) Uninstall Bahmni Logger   
      10) Go to Settings->Companies (Edit and add your hospital details: name, logo, address, etc.
      11) Go to Warehouse -> Configurations/Warehouses -> Edit/Add a warehouse (keep settings default).
      12) Go to Sales -> Shop -> Edit/Add your shop  (and choose Warehouse) -- Shop name must be "Pharmacy".
      13) To add a Billing User, go to Settings -> Users -> Add User. Give access rights: 
           Sales: Manager
           Warehouse: None or User (One of the authorization: Warehouse or Purchases Needs to be User to make bills)
           Account & Finance: Accountant
           Purchases: None or User (One of the authorization: Warehouse or Purchases Needs to be User to make bills)
           Human Resources: Employee
           Sharing: Blank
           Adminstration: Blank

           In Technical settings give:
           Manage Multiple Units of Measure
           Manage Serial Numbers
           Enabled adding final SaleOrder charge
           Manage Multiple Locations and Warehouses
           
      14) Create a product category named "Drug" under "All products / Saleable". Goto to Sales > Configuration > Products (Drop Down) > Product Categories.


BACKUP/REPLICATION
====================
NOTE: 
If you want to set up a Replication Backup for Databases, read these documents: 
https://github.com/Bhamni/bahmni-environment/blob/master/mysql-replication/README.md
https://github.com/Bhamni/bahmni-environment/blob/master/puppet/modules/postgresql/README.md

===================================================================================================
Some todos we identified
===================================================================================================
TODO:

- remove local packages dependencies - remove (require yum repo) 
------ create a new provision.pp file which will install all packages from internet.
------ Note that mySQL installation requires addition of another yum repo. This will be needed for Internet-mode installation.
- remove goServer
- Check how to enable download of packages, currently script downloads through public ip of GO of all current builds. we might not to use GO for package download and/or the bleeding packages 
* delete - /packages/localrepo ?
