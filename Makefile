install:
	brew bundle 
	make osx-docker
	make configure-local-server
	if ! grep -q "127.0.0.1 sample-project.ampdev.co" "/etc/hosts"; then echo "127.0.0.1 sample-project.ampdev.co" | sudo tee -a /etc/hosts; fi;
	sudo apachectl stop && sleep 1 && sudo apachectl start;

osx-docker:
	docker-compose --file=./docker-compose.yml up -d
	
configure-local-server:
	sed \
	-e "s;%HOST_NAME%;sample-project;g" \
	-e "s;%DOCUMENT_ROOT%;$(PWD);g" \
	-e "s;%APACHE_LOG_DIR%;$(shell brew --prefix)/var/log/httpd/;g" \
	systems/apache/local-osx.conf.template > $(shell brew --prefix)/etc/httpd/vhosts/sample-project-local-osx.conf
