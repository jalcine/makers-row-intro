all:
	bundle install
	rm -f output_real.txt
	ruby app.rb < input.txt > output_real.txt

test:
	cat output_real.txt
	diff output.txt output_real.txt
