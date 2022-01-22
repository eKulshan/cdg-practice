test:
	rspec .
test-one:
	rspec . -P "**/move_users_spec.rb"
lint:
	rubocop . -a
lint-force:
	rubocop . -A 