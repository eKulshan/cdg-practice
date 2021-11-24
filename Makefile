test:
	rspec .
lint:
	rubocop . -a
lint-force:
	rubocop . -A