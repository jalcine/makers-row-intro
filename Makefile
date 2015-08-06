all: @quiet
	rm -f output_real.txt
	ruby app.rb < input.txt > output_real.txt
	cat output_real.txt
