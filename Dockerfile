# Build with docker build -t adrian.arroyocalle/jekyll .
# Run with docker run -d adrian.arroyocalle/jekyll

FROM learn/tutorial

MAINTAINER adrian.arroyocalle

RUN apt-get update
RUN apt-get install -y rubygems
RUN gem install bundle
RUN bundle install

WORKDIR .

EXPOSE 4000

CMD ["bundle","exec","jekyll","serve"]
