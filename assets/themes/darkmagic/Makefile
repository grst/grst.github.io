styles.min.css: bootswatch/yeti/bootstrap.min.css
	cp bootswatch/yeti/bootstrap.min.css styles.min.css

bootswatch/yeti/bootstrap.min.css: $(wildcard bootswatch/yeti/*.less)
	cd bootswatch && grunt swatch:yeti

all: styles.min.css

clean: 
	rm bootswatch/yeti/bootstrap*.css
