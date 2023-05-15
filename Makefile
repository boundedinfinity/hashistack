makefile_dir		:= $(abspath $(shell pwd))

.PHONY: networks-ensure networks-destroy consul-ensure consul-destroy

list:
	@grep '^[^#[:space:]].*:' Makefile | grep -v ':=' | grep -v '^\.' | sed 's/:.*//g' | sed 's/://g' | sort

networks-ensure:
	cd $(makefile_dir)/networks && terraform init && terraform apply

networks-destroy:
	cd $(makefile_dir)/networks && terraform init && terraform destroy


consul-ensure:
	cd $(makefile_dir)/consul && terraform init && terraform apply

consul-destroy:
	cd $(makefile_dir)/consul && terraform init && terraform destroy