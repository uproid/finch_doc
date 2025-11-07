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
#RUN chmod -R a+rxw .
# FROM subfuzion/dart-scratch
# COPY --from=build /www/lib/watcher.exe /www/lib/watcher.exe
# COPY any other directories or files you may require at runtime, ex:
#COPY --from=0 /app/static/ /app/static/
EXPOSE 9902 9901
CMD ["/www/lib/app.exe"]
#CMD [ "dart","run","--enable-asserts", "--observe=9901", "--enable-vm-service", "--disable-service-auth-codes","/www/lib/watcher.dart" ]
