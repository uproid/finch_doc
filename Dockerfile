FROM uproid/finch:latest AS dev
WORKDIR /www


ENV WIDGETS_TYPE='html.twig'
ENV LANGUAGE_TYPE='./lib/languages'
ENV WIDGETS_PATH='./lib/widgets'
ENV PUBLIC_DIR='./public'

COPY . .
RUN dart pub get 
RUN dart pub get --offline

EXPOSE 9902 9901
CMD ["finch", "serve", "-p", "/www/lib/watcher.dart"]
