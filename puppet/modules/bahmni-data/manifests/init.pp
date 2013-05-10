class bahmni-data {
	$bahmni_data_temp = "${temp_dir}/bahmni-data"

	file { "${bahmni_data_temp}" :
		ensure => directory,
		mode 	 => 666,
    owner       => "${bahmni_user}",
	}

	file { "${bahmni_data_temp}/bahmni-flyway-ant.xml" :
    path    => "${bahmni_data_temp}/bahmni-flyway-ant.xml",
    content     => template("bahmni-data/bahmni-flyway-ant.erb"),
	  ensure      => present,
	  owner       => "${bahmni_user}",
	  mode        => 544,
	  require			=> File["${bahmni_data_temp}"]
	}

  file { "${bahmni_data_temp}/flyway-migration.sh" :
    path    => "${bahmni_data_temp}/flyway-migration.sh",
    ensure      => present,
    content     => template("bahmni-data/flyway-migration.erb"),
    owner       => "${bahmni_user}",
    mode        => 544,
    require     => File["${bahmni_data_temp}"]
  }

  file { "${bahmni_data_temp}/lib" :
    ensure => directory,
    mode  => 666
  }

  exec { "bahmni db upgrade" :
  	command		=> "sh flyway-migration.sh ${build_output_dir}/bahmni.properties ${build_output_dir}/openmrs-data-jars.zip ${ant_home} ${deployment_log_expression}",
  	user 			=> "${bahmni_user}",
  	require 	=> [File["${bahmni_data_temp}/bahmni-flyway-ant.xml"], File["${bahmni_data_temp}/flyway-migration.sh"]],
  	path 			=> "${os_path}",
  	cwd				=> "${bahmni_data_temp}"
  }
}