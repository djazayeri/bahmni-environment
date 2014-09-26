class implementation_config($implementation_name = $implementation_name) {
  class {"implementation_config::openmrs": implementation_name => "$implementation_name"}
  if $deploy_bahmni_openelis == "true" {
	  class {"implementation_config::openelis": implementation_name => "$implementation_name"}
  }
  if $deploy_bahmni_openerp == "true" {
	  class {"implementation_config::openerp": implementation_name => "$implementation_name"}
  }
}