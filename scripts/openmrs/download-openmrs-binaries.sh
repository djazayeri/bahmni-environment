rm -f $1/*

wget -O $1/addresshierarchy-2.2.10-SNAPSHOT.omod https://ci-bahmni.thoughtworks.com/job/Build-Address-Hierarchy/lastSuccessfulBuild/artifact/omod/target/addresshierarchy-2.2.10-SNAPSHOT.omod
wget -O $1/bahmnicore-0.2-SNAPSHOT.omod https://ci-bahmni.thoughtworks.com/job/Build-Bahmni-Core/lastSuccessfulBuild/artifact/omod/target/bahmnicore-0.2-SNAPSHOT.omod
wget -O $1/bahmnicore-mail-appender-0.2-SNAPSHOT-jar-with-dependencies.jar https://ci-bahmni.thoughtworks.com/job/Build-Bahmni-Core/lastSuccessfulBuild/artifact/bahmni-mail-appender/target/bahmnicore-mail-appender-0.2-SNAPSHOT-jar-with-dependencies.jar
wget -O $1/jss-old-data-0.2-SNAPSHOT-jar-with-dependencies.jar https://ci-bahmni.thoughtworks.com/job/Build-Bahmni-Core/lastSuccessfulBuild/artifact/jss-old-data/target/jss-old-data-0.2-SNAPSHOT-jar-with-dependencies.jar
wget -O $1/openmrs.war https://ci-bahmni.thoughtworks.com/job/Build-OpenMRS-Core-Module/lastSuccessfulBuild/artifact/webapp/target/openmrs.war
wget -O $1/openmrs-data-jars.zip https://ci-bahmni.thoughtworks.com/job/Build-OpenMRS-Data/lastSuccessfulBuild/artifact/target/openmrs-data-jars.zip
wget -O $1/webservices.rest-1.2-SNAPSHOT.0a1e33.omod https://ci-bahmni.thoughtworks.com/job/Build-OpenMRS-Rest-Module/lastSuccessfulBuild/artifact/omod/target/webservices.rest-1.2-SNAPSHOT.0a1e33.omod