.PHONY: test-rust test-python test-dart test-ruby test-cpp test

test: test-cpp test-rust test-python test-dart test-ruby

test-cpp:
	mkdir -p build && cd build && cmake .. && make && ./unit_tests

test-rust:
	cd rust && cargo test

test-python:
	cd python && pytest

test-dart:
	cd dart && dart test

test-ruby:
	cd ruby && ruby -Ilib test/test_unit_conversion.rb
