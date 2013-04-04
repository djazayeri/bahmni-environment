class openmrs ( $tomcatInstallationDirectory) {
    exec {"download-openmrs-war" :
            command     => "/usr/bin/wget -O /tmp/openmrs-${openMRSVersion}.war http://sourceforge.net/projects/openmrs/files/releases/OpenMRS_${openMRSVersion}/openmrs.war",
            timeout     => 0,
            provider    => "shell",
			      user        => "${jssUser}",
            onlyif      => "! test -f /tmp/openmrs-${openMRSVersion}.war"
    }
    
    exec {"install-openmrs" :
            command     => "cp /tmp/openmrs-${openMRSVersion}.war ${tomcatInstallationDirectory}/webapps/openmrs.war",
			      user        => "${jssUser}",
            onlyif      => "test -d ${tomcatInstallationDirectory}",
            require		=> Exec["download-openmrs-war"],            
    }
    
    exec {"restart_tomcat" :
          command     => "/etc/init.d/tomcat restart",
          user        => "${jssUser}",
          require		=> Exec["install-openmrs"],
  	}  	
}
