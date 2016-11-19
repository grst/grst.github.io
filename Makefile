all: 
	bundle exec jekyll build	

clean:
	rm -rfv _site

theme:
	git co theme _layouts _includes _sass assets

serve:
	bundle exec jekyll serve
