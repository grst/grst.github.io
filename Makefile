clean:
	rm -rfv _site

all: 
	bundle exec jekyll build	

serve:
	bundle exec jekyll serve
