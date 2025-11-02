.PHONY:be fe lambda zip
fe:
	cd frontend && npm run dev

be:
	make lambda\
    && cd terraform/env/dev && sam build && sam local start-api

lambda:
	cd lambda && npm run build \
    && cd .. && make zip

zip:
	@set -e; \
	mkdir -p terraform/modules/lambda; \
	for dir in lambda/main/*; do \
	  if [ -d "$$dir" ]; then \
	    name=$$(basename "$$dir"); \
	    src_file="$$dir/dist/index.js"; \
	    if [ -f "$$src_file" ]; then \
	      echo "Zipping $$src_file -> terraform/modules/lambda/$${name}.zip"; \
	      zip -j -q "terraform/modules/lambda/$${name}.zip" "$$src_file"; \
	    else \
	      echo "No build output for $$name (missing $$src_file), skipping"; \
	    fi; \
	  fi; \
	done