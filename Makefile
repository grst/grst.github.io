all: 
	bundle exec jekyll build	

clean:
	rm -rfv _site

serve:
	bundle exec jekyll serve
