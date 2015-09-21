# hyconn2015_hydra9

Because of presenter error, you need to do these things:

sudo cp solr_conf/collection1/schema.xml /var/lib/tomcat7/solr/collection1/conf/

change in fedora.yml:
http://127.0.0.1:8983/fedora/rest -> http://127.0.0.1:8080/fcrepo/rest

change in solr.yml:
http://localhost:8983/solr/development -> http://localhost:8080/solr/collection1
