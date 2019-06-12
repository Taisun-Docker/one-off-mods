## Buildstage ##
FROM lsiobase/alpine:3.9 as buildstage

RUN \
 echo "**** install packages ****" && \
 apk add --no-cache \
	curl \
	unzip && \
 echo "**** grab cablibre bin ****" && \
 CALIBRE_RELEASE=$(curl -sX GET "https://api.github.com/repos/kovidgoyal/calibre/releases/latest" \
	| awk '/tag_name/{print $4;exit}' FS='[""]' | sed 's/^v//g' ) && \ 
 mkdir -p /root-layer/opt/calibre && \
 curl -o \
	/tmp/calibre.txz -L \
	"https://github.com/kovidgoyal/calibre/releases/download/v${CALIBRE_RELEASE}/calibre-${CALIBRE_RELEASE}-x86_64.txz" && \
 tar -xf \
	/tmp/calibre.txz \
	-C /root-layer/opt/calibre

# copy local files
COPY root/ /root-layer/

## Single layer deployed image ##
FROM scratch

# Add files from buildstage
COPY --from=buildstage /root-layer/ /
