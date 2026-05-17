FROM uproid/finch:latest AS build
WORKDIR /www


ENV WIDGETS_TYPE='html.twig'
ENV LANGUAGE_TYPE='./lib/languages'
ENV WIDGETS_PATH='./lib/widgets'
ENV PUBLIC_DIR='./public'


COPY . .

RUN dart pub get 
RUN dart pub get --offline 
RUN dart build cli -t ./bin/app.dart -o ./build
RUN cp -r ./build/bundle/bin/ ./
#RUN chmod -R a+rxw ./bin

EXPOSE 9902 9901
CMD ["/www/bin/app"]

FROM uproid/finch:latest AS dev
WORKDIR /www


ENV WIDGETS_TYPE='html.twig'
ENV LANGUAGE_TYPE='./lib/languages'
ENV WIDGETS_PATH='./lib/widgets'
ENV PUBLIC_DIR='./public'


RUN dart pub get 
RUN dart pub get --offline

EXPOSE 9902 9901
CMD ["finch", "serve", "-p", "/www/bin/watcher.dart"]
