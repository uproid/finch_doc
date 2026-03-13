FROM dart:stable AS build
WORKDIR /www


ENV WIDGETS_TYPE='html.twig'
ENV LANGUAGE_TYPE='./lib/languages'
ENV WIDGETS_PATH='./lib/widgets'
ENV PUBLIC_DIR='./public'


COPY . .

RUN dart pub get 
RUN dart pub get --offline 
RUN chmod -R a+rxw ./lib
RUN dart compile exe /www/lib/app.dart -o /www/lib/app.exe

EXPOSE 9902 9901
CMD ["/www/lib/app.exe"]
